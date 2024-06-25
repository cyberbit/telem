-- Fluent by cyberbit
-- MIT License
-- Version 0.2.0

---@class cyberbit.Fluent
---@field value any
---@field queue function[]
---@field params { [string]: any }
---@overload fun(value?: any): cyberbit.Fluent
local Fluent = setmetatable({}, {
    ---@param class cyberbit.Fluent
    ---@param ... any
    ---@return cyberbit.Fluent
    __call = function (class, ...)
        local obj = {}

        setmetatable(obj, { __index = class })

        class.constructor(obj, ...)

        return obj
    end
})

--- Constructs a new instance of the Fluent class.
---
--- If a value is not provided here, it can be set later using `from()`
--- before chain methods, or any time before `result()` for lazy chains.
---@param value? any
function Fluent:constructor (value)
    self.value = value

    self.queue = {}
    self.params = {}

    self.isLazy = false
    self.isImmutable = false
end

--- Defer execution until result() is called. This should be used at the front of the chain.
function Fluent:lazy ()
    self.isLazy = true

    return self
end

--- Return new Fluent instance after every chain method. This should be used at the front of the chain.
function Fluent:immutable ()
    self.isImmutable = true

    return self
end

--- Constructs a new lazy immutable Fluent instance.
--- This is suitable for use with subroutine methods like `mapSub`.
function Fluent.fn()
    return Fluent():lazy():immutable()
end

--- Internal function facilitating lazy execution
---@protected
---@param func fun(this: cyberbit.Fluent)
function Fluent:_enqueue (func)
    return self:_mutate(function (mut)
        if mut.isLazy then
            mut.queue[#mut.queue + 1] = func
        else
            func(mut)
        end
    
        return mut
    end)
end

--- Internal function facilitating immutability
---@protected
---@param func fun(mut: cyberbit.Fluent): cyberbit.Fluent
function Fluent:_mutate (func)
    func = func or function (v) return v end
    
    if self.isImmutable then
        local clone = self:clone()
        
        return func(clone)
    else
        return func(self)
    end
end

--- Clones the Fluent object. Value is copied by reference.
function Fluent:clone ()
    local clone = Fluent(self.value)

    for k,v in ipairs(self.queue) do
        clone.queue[k] = v
    end

    for k,v in pairs(self.params) do
        clone.params[k] = v
    end

    clone.isLazy = self.isLazy
    clone.isImmutable = self.isImmutable

    return clone
end

--- Call a method on the value.
---@param method string Method name
---@param ... any Method arguments
function Fluent:call (method, ...)
    local args = {...}

    return self:_enqueue(function (this)
        local success, result = pcall(this.value[method], table.unpack(args))

        if not success then
            error('Fluent.call: ' .. result)
        end
        
        this.value = result
    end)
end

--- Set a parameter on the Fluent object. This can be used to pass data between chain methods.
--- Parameters are accessible via `self.params`.
---@param key string Parameter name
---@param value any Parameter value
function Fluent:with (key, value)
    return self:_mutate(function (mut)
        mut.params[key] = value

        return mut
    end)
end

--- Set the value of the Fluent object. This is typically used when preparing to execute an uninitialized lazy chain.
---@param value any
function Fluent:from (value)
    return self:_mutate(function (mut)
        mut.value = value

        return mut
    end)
end

--- Convert the value to a boolean using Lua's truthiness rules.
function Fluent:toBool ()
    return self:_enqueue(function (this)
        this.value = this.value and true or false
    end)
end

--- Convert the value to a flag (0 or 1) using Lua's truthiness rules.
function Fluent:toFlag ()
    return self:_enqueue(function (this)
        this.value = this.value and 1 or 0
    end)
end

--- Convert the value to another using a provided enum table. The value is used as a key to look up the new value.
---@param lookup table
function Fluent:toLookup (lookup)
    return self:_enqueue(function (this)
        this.value = lookup[this.value]
    end)
end

--- Pass the value through a function and use the return value as the new value.
---@param func fun(value: any): any
function Fluent:transform (func)
    return self:_enqueue(function (this)
        this.value = func(this.value)
    end)
end

--- Iterate through the value, passing each key-value pair to a function.
--- If the function returns false, iteration will stop.
---@param func fun(key: any, value: any): boolean|nil
function Fluent:each (func)
    return self:_enqueue(function (this)
        local continue

        for k, v in pairs(this.value) do
            continue = func(k, v)

            if type(continue) == 'boolean' and not continue then
                break
            end
        end
    end)
end

--- Filter the value using a function. If the function returns true, the value is kept.
--- If no function is provided, the value is kept if it is truthy.
---
--- For the inverse of this function, see `reject()`
---@param func? fun(key: any, value: any): boolean
function Fluent:filter (func)
    func = func or function (_, v) return v and true or false end

    return self:_enqueue(function (this)
        local result = {}

        for k, v in pairs(this.value) do
            if func(k, v) then
                result[k] = v
            end
        end

        this.value = result
    end)
end
--- Filter the value using a pattern. Elements that match the pattern are kept.
--- Values must be compatible with `string.match`.
--- @param pattern string
function Fluent:filterMatch (pattern)
    return self:_enqueue(function (this)
        local result = {}

        for k, v in pairs(this.value) do
            if string.match(v, pattern) then
                result[k] = v
            end
        end

        this.value = result
    end)
end

--- Filter the value using a lazy Fluent object. Elements that result in the
--- Fluent object returning truthy values are kept.
---@param fl cyberbit.Fluent
function Fluent:filterSub (fl)
    return self:filter(function (_, v)
        return fl:from(v):result()
    end)
end

--- Find the first element that passes a test function and returns its value.
--- If no function is provided, the first element's value is returned.
---
--- The iterator used is determined by the first element's key.
--- If it is numeric, `ipairs` is used, otherwise `pairs` is used.
---@param func? fun(key: any, value: any): boolean
function Fluent:first (func)
    func = func or function () return true end

    return self:_enqueue(function (this)
        local iter = type(next(this.value)) == 'number' and ipairs or pairs

        for k, v in iter(this.value) do
            if func(k, v) then
                this.value = v
                return
            end
        end

        this.value = nil
    end)
end

--- Find the first element that has a specified key-value pair.
---@param key any
---@param value any
function Fluent:firstWhere (key, value)
    return self:first(function (_, v)
        return v[key] == value
    end)
end

--- Get a value from the value using a key. If the key does not exist, a default value can be provided.
---
--- The key can be a dot-separated string to access nested tables: `key1.key2.key3`.
--- If a key is not found (or results in nil), the default value is returned.
--- @param key any
--- @param default any
--- @return cyberbit.Fluent
function Fluent:get (key, default)
    return self:_enqueue(function (this)
        local keys = {}
    
        if type(key) == 'string' then
            for k in string.gmatch(key, "[^%.]+") do
                table.insert(keys, k)
            end
        else
            keys = { key }
        end

        local value = this.value

        for k, v in ipairs(keys) do
            if type(value) == 'nil' then
                value = default

                break
            end

            value = value[v]
        end

        this.value = type(value) == 'nil' and default or value
    end)
end

--- Group the value by a key.
---
--- ```
--- fluent({
---   { k = 'a', v = 1 },
---   { k = 'b', v = 2 },
---   { k = 'a', v = 3 }
---  }):groupBy('k'):result()
--- 
--- result = {
---   a = {{ k = 'a', v = 1 }, { k = 'a', v = 3 }},
---   b = {{ k = 'b', v = 2 }}
--- }
--- ```
---@param key any
function Fluent:groupBy (key)
    return self:_enqueue(function (this)
        local result = {}

        for _, v in pairs(this.value) do
            result[v[key]] = result[v[key]] or {}

            table.insert(result[v[key]], v)
        end

        this.value = result
    end)
end

--- Check if the value has a key.
---
--- If the key exists but the value is nil, this will return false.
---@param key any
function Fluent:has (key)
    return self:_enqueue(function (this)
        this.value = this.value[key] ~= nil
    end)
end

--- Remove any elements from the value that are not in the provided list.
---
--- The result keys are determined by the first key of the current value.
--- If it is numeric, the result will be reindexed numerically.
--- Otherwise, the current value's keys will be preserved.
---@param superset any[]
function Fluent:intersect (superset)
    return self:_enqueue(function (this)
        local result = {}

        local iter = type(next(this.value)) == 'number' and ipairs or pairs

        for k, v in iter(this.value) do
            for _, ov in iter(superset) do
                if v == ov then
                    if iter == ipairs then
                        table.insert(result, v)
                    else
                        result[k] = v
                    end
                end
            end
        end

        this.value = result
    end)
end

--- Return a list of elements from the value that are not in the provided list.
---
--- The result keys are determined by the first key of the current value.
--- If it is numeric, the result will be reindexed numerically.
--- Otherwise, the current value's keys will be preserved.
---@param superset any[]
function Fluent:diff (superset)
    return self:_enqueue(function (this)
        local result = {}

        local iter = type(next(this.value)) == 'number' and ipairs or pairs

        for k, v in iter(this.value) do
            local found = false

            for _, ov in iter(superset) do
                if v == ov then
                    found = true
                    break
                end
            end

            if not found then
                if iter == ipairs then
                    table.insert(result, v)
                else
                    result[k] = v
                end
            end
        end

        this.value = result
    end)
end

--- Get a list of the value's keys.
function Fluent:keys ()
    return self:_enqueue(function (this)
        local result = {}

        for k, _ in pairs(this.value) do
            table.insert(result, k)
        end

        this.value = result
    end)
end

--- Get the last element that passes a test function.
--- If no function is provided, the last element is returned.
---
--- The iterator used is determined by the first element's key.
--- If it is numeric, `ipairs` is used, otherwise `pairs` is used.
---@param func? fun(key: any, value: any): boolean
function Fluent:last (func)
    func = func or function () return true end

    return self:_enqueue(function (this)
        local iter = type(next(this.value)) == 'number' and ipairs or pairs

        local last

        for k, v in iter(this.value) do
            if func(k, v) then
                last = v
            end
        end

        this.value = last
    end)
end

--- Iterate through the value, passing each key-value pair to a function.
--- The function can modify the key and value, returning both.
---
--- If duplicate keys are returned, the last key-value pair will be kept.
--- @param func fun(key: any, value: any): newKey: any, newValue: any
function Fluent:mapWithKeys (func)
    return self:_enqueue(function (this)
        local result = {}

        for k, v in pairs(this.value) do
            local newKey, newValue = func(k, v)

            result[newKey] = newValue
        end

        this.value = result
    end)
end

--- Iterate through the value, passing each key-value pair to a function.
--- The function can modify the key's value and return it, updating the value at that key.
---@param func fun(key: any, value: any): newValue: any
function Fluent:map (func)
    return self:mapWithKeys(function (k, v)
        return k, func(k, v)
    end)
end

--- Iterate through the value, passing each element to a function.
--- The function can modify the value and return it, updating the value at that key.
---@param func fun(value: any): newValue: any
function Fluent:mapValues (func)
    return self:map(function (_, v)
        return func(v)
    end)
end

--- Iterate through the value, passing each element through a provided lazy Fluent object.
--- The function can call chain methods on the Fluent object as needed. The result of
--- the chain will be the new value at that key.
--- @param fl cyberbit.Fluent
function Fluent:mapSub (fl)
    return self:mapValues(function (v)
        return fl:from(v):result()
    end)
end
--- Get the first match of a pattern using `string.match`.
--- Value must be compatible with `string.match`.
--- @param pattern string
function Fluent:match (pattern)
    return self:_enqueue(function (this)
        this.value = string.match(this.value, pattern)
    end)
end

--- Select only the specified keys from the value.
---@param keys any[]
function Fluent:only (keys)
    return self:_enqueue(function (this)
        local result = {}

        for _, key in pairs(keys) do
            result[key] = this.value[key]
        end

        this.value = result
    end)
end

--- Iterate through the value, reducing to a list of values at the key specified.
---
--- ```
--- fluent({
---   { k = 'a' },
---   { k = 'b' },
---   { k = 'c' }
--- }):pluck('k'):result()
---
--- result = {'a', 'b', 'c'}
--- ```
---@param key any
function Fluent:pluck (key)
    return self:_enqueue(function (this)
        local result = {}

        for _, v in pairs(this.value) do
            table.insert(result, v[key])
        end

        this.value = result
    end)
end

--- Select one or more key-value pairs from the value at random.
---
--- If the count is greater than the number of keys, an error will be thrown.
---@param count? integer Number of elements to select, defaults to 1
function Fluent:random (count)
    count = count or 1

    return self:_enqueue(function (this)
        local keys = Fluent(this.value):keys():result()

        if count > #keys then
            error('Fluent.random: count is greater than the number of keys')
        end

        if count == 1 then
            local key = keys[math.random(1, #keys)]

            this.value = this.value[key]

            return
        else
            local result = {}

            for i = 1, count do
                local key = table.remove(keys, math.random(1, #keys))

                result[key] = this.value[key]
            end

            this.value = result
        end
    end)
end

--- Reduce the value's elements to a single value using a function.
---@param func fun(initial: any, key: any, value: any): reduction: any
---@param initial any
function Fluent:reduce (func, initial)
    return self:_enqueue(function (this)
        local innerInitial = initial

        for k, v in pairs(this.value) do
            innerInitial = func(innerInitial, k, v)
        end

        this.value = innerInitial
    end)
end

--- Filter the value using a function. If the function returns false, the value is kept.
--- If no function is provided, the value is kept if it is falsy.
---
--- For the inverse of this function, see `filter()`
---@param func? fun(key: any, value: any): boolean
function Fluent:reject (func)
    func = func or function (_, v) return v and true or false end

    return self:_enqueue(function (this)
        local result = {}

        for k, v in pairs(this.value) do
            if not func(k, v) then
                result[k] = v
            end
        end

        this.value = result
    end)
end

--- Replace key-value pairs with specified key-value pairs.
--- If a key does not exist, it will be created.
---
--- ```
--- fluent({ a = 1, b = 2 }):replace({ a = 3, c = 4 }):result()
---
--- result = { a = 3, b = 2, c = 4 }
--- ```
---@param value table
function Fluent:replace (value)
    return self:_enqueue(function (this)
        for k, v in pairs(value) do
            this.value[k] = v
        end
    end)
end

--- Select only the specified keys from the value's elements.
--- @param keys any[]
function Fluent:select (keys)
    return self:_enqueue(function (this)
        local result = {}

        for k, v in pairs(this.value) do
            result[k] = {}

            for _, key in pairs(keys) do
                result[k][key] = v[key]
            end
        end

        this.value = result
    end)
end

--- Sort the value's elements, optionally with a comparison function.
--- Uses `table.sort` internally.
--- @param func? fun(a: any, b: any): boolean
function Fluent:sort (func)
    return self:_enqueue(function (this)
        table.sort(this.value, func)
    end)
end

--- Sort the value by a key.
---@param key any
function Fluent:sortBy (key)
    return self:sort(function (a, b)
        return a[key] < b[key]
    end)
end

--- Sum all the value's elements.
---
--- If a key is provided, the value at that key is summed.
--- If a groupBy key is provided, the value is grouped by that key and summed.
---@param key? any Key to sum
---@param groupBy? any Key to group by before summing
function Fluent:sum (key, groupBy)
    return self:_enqueue(function (this)
        if not groupBy then
            local sum = 0

            for _, v in pairs(this.value) do
                sum = sum + (key and v[key] or v)
            end

            this.value = sum
        else
            local result = {}

            for _, v in pairs(this.value) do
                result[v[groupBy]] = (result[v[groupBy]] or 0) + v[key]
            end

            this.value = result
        end
    end)
end

--- Pass the value through a function, discarding the return value. This can be used for side effects.
---@param func fun(value: any)
function Fluent:tap (func)
    return self:_enqueue(function (this)
        func(this.value)
    end)
end

--- Reindex the value's elements numerically.
--- Order of elements is not guaranteed.
function Fluent:values()
    return self:_enqueue(function (this)
        local result = {}

        for _, v in pairs(this.value) do
            table.insert(result, v)
        end

        this.value = result
    end)
end

--- Return the final value after processing the chain. This should be called at the end of the chain.
--- For lazy chains, this will execute all queued functions in sequence.
--- For immutable chains, this will not mutate the original Fluent object.
---@return any
function Fluent:result ()
    if not self.isLazy then
        return self.value
    end

    local mut = self.isImmutable and self or self:clone()

    for _, func in pairs(mut.queue) do
        func(mut)
    end

    return mut.value

    -- return self:_mutate(function (mut)
    --     for _, func in pairs(mut.queue) do
    --         func(mut)
    --     end
    
    --     return mut.value
    -- end)
end

--- Pretty-print the value using `cc.pretty`.
function Fluent:pprint ()
    return self:_enqueue(function (this)
        require('cc.pretty').pretty_print(this.value)
    end)
end

return Fluent