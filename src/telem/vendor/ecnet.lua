local e={}local t,a,o=require,{},{startup=e}
local function i(n)local s=o[n]
if s~=nil then if s==e then
error("loop or previous error loading module '"..n..
"'",2)end;return s end;o[n]=e;local h=a[n]if h then s=h(n)elseif t then s=t(n)else
error("cannot load '"..n.."'",2)end;if s==nil then s=true end;o[n]=s;return s end
a["ecnet.util"]=function(...)
local n={__tostring=function(r)return string.char(unpack(r))end,__index={toHex=function(r)return("%02x"):rep(
#r):format(unpack(r))end,isEqual=function(r,d)if
type(d)~="table"then return false end;if#r~=#d then return false end;local l=0
for u=1,
#r do l=bit32.bor(l,bit32.bxor(r[u],d[u]))end;return l==0 end}}
local function s(r,d)local l=fs.open(r,"wb")l.write(d)l.close()end
local function h(r)local d=fs.open(r,"rb")local l=d.readAll()d.close()return l end;return{byteTableMT=n,saveFile=s,loadFile=h}end
a["ecnet.symmetric.siphash"]=function(...)local n=i("ecnet.util")local s=bit32.bxor
local h=bit32.band;local r=bit32.rshift;local d=n.byteTableMT;local function l(f)local m=#f
while(#f%8 ~=7)do f[#f+1]=0 end;f[#f+1]=m%256 end
local function u(m,f,w,y,p,v,b,g)local k,q;m=m+w;f=(f+y+ (m>
0xffffffff and 1 or 0))%
0x100000000;m=m%0x100000000;p=p+b;v=
(
v+g+ (p>0xffffffff and 1 or 0))%0x100000000;p=p%0x100000000;k=
h(w,0xfff80000)/0x80000;q=h(y,0xfff80000)/0x80000;w=
w*0x2000+q;y=y*0x2000+k;k=h(b,0xffff0000)/0x10000;q=
h(g,0xffff0000)/0x10000;b=b*0x10000+q;g=g*0x10000+k
w=s(w,m)y=s(y,f)b=s(b,p)g=s(g,v)m,f=f,m;p=p+w
v=(v+y+
(p>0xffffffff and 1 or 0))%0x100000000;p=p%0x100000000;m=m+b;f=
(f+g+ (m>0xffffffff and 1 or 0))%0x100000000;m=m%0x100000000;k=
h(w,0xffff8000)/0x8000;q=h(y,0xffff8000)/0x8000;w=
w*0x20000+q;y=y*0x20000+k;k=h(b,0xfffff800)/0x800;q=
h(g,0xfffff800)/0x800;b=b*0x200000+q;g=g*0x200000+k
w=s(w,p)y=s(y,v)b=s(b,m)g=s(g,f)p,v=v,p;return m,f,w,y,p,v,b,g end
local function c(m,f)
local w=type(f)=="table"and
{string.char(unpack(f)):byte(1,-1)}or{tostring(f):byte(1,-1)}
local y=type(m)=="table"and
{string.char(unpack(m)):byte(1,-1)}or{tostring(m):byte(1,-1)}
assert(#w==16,"SipHash: Invalid key length ("..#w.."), must be 16")l(y)
local p=s(w[1],w[2]*0x100,w[3]*0x10000,w[4]*0x1000000,0x70736575)
local v=s(w[5],w[6]*0x100,w[7]*0x10000,w[8]*0x1000000,0x736f6d65)
local b=s(w[9],w[10]*0x100,w[11]*0x10000,w[12]*0x1000000,0x6e646f6d)
local g=s(w[13],w[14]*0x100,w[15]*0x10000,w[16]*0x1000000,0x646f7261)
local k=s(w[1],w[2]*0x100,w[3]*0x10000,w[4]*0x1000000,0x6e657261)
local q=s(w[5],w[6]*0x100,w[7]*0x10000,w[8]*0x1000000,0x6c796765)
local j=s(w[9],w[10]*0x100,w[11]*0x10000,w[12]*0x1000000,0x79746573)
local x=s(w[13],w[14]*0x100,w[15]*0x10000,w[16]*0x1000000,0x74656462)
for T=1,#y,8 do
j=s(y[T],y[T+1]*0x100,y[T+2]*0x10000,y[T+3]*0x1000000,j)
x=s(y[T+4],y[T+5]*0x100,y[T+6]*0x10000,y[T+7]*0x1000000,x)p,v,b,g,k,q,j,x=u(p,v,b,g,k,q,j,x)p,v,b,g,k,q,j,x=u(p,v,b,g,k,q,j,x)
p=s(y[T],
y[T+1]*0x100,y[T+2]*0x10000,y[T+3]*0x1000000,p)
v=s(y[T+4],y[T+5]*0x100,y[T+6]*0x10000,y[T+7]*0x1000000,v)
if T%64000 ==0 then os.queueEvent("")os.pullEvent("")end end;k=s(k,0xff)p,v,b,g,k,q,j,x=u(p,v,b,g,k,q,j,x)
p,v,b,g,k,q,j,x=u(p,v,b,g,k,q,j,x)p,v,b,g,k,q,j,x=u(p,v,b,g,k,q,j,x)p,v,b,g,k,q,j,x=u(p,v,b,g,k,q,j,x)
local z=s(p,b,k,j)local _=s(v,g,q,x)
local E={r(_,24)%256,r(_,16)%256,r(_,8)%256,_%256,r(z,24)%256,r(z,16)%
256,r(z,8)%256,z%256}return setmetatable(E,d)end;return{mac=c}end
a["ecnet.symmetric.sha256"]=function(...)local n=i("ecnet.util")local s=_G.bit;local h=2^32;local r=bit32 and
bit32.band or s.band
local d=bit32 and bit32.bnot or s.bnot;local l=bit32 and bit32.bxor or s.bxor;local u=
bit32 and bit32.lshift or s.blshift
local c=unpack or table.unpack;local m=n.byteTableMT
local function f(_,E)local T=_/ (2^E)local A=T%1;return(T-A)+A*h end;local function w(_,E)local T=_/ (2^E)return T-T%1 end
local y={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
local p={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
local function v(_)local E,T=0,0;if 0xFFFFFFFF-E<_ then T=T+1
E=_- (0xFFFFFFFF-E)-1 else E=E+_ end;return T,E end
local function b(_,E)return
u((_[E]or 0),24)+u((_[E+1]or 0),16)+
u((_[E+2]or 0),8)+ (_[E+3]or 0)end
local function g(_)local E=#_;local T={}_[#_+1]=0x80;while#_%64 ~=56 do _[#_+1]=0 end;local A=math.ceil(#
_/64)
for O=1,A do T[O]={}for I=1,16 do T[O][I]=b(_,1+ ((O-1)*64)+
((I-1)*4))end end;T[A][15],T[A][16]=v(E*8)return T end
local function k(_,E)
for D=17,64 do
local L=l(l(f(_[D-15],7),f(_[D-15],18)),w(_[D-15],3))
local U=l(l(f(_[D-2],17),f(_[D-2],19)),w(_[D-2],10))_[D]=(_[D-16]+L+_[D-7]+U)%h end;local T,A,O,I,N,S,H,R=c(E)
for D=1,64 do local L=l(l(f(N,6),f(N,11)),f(N,25))
local U=l(r(N,S),r(d(N),H))local C=(R+L+U+p[D]+_[D])%h
local M=l(l(f(T,2),f(T,13)),f(T,22))local F=l(l(r(T,A),r(T,O)),r(A,O))local W=(M+F)%h;R,H,S,N,I,O,A,T=H,S,N,(I+
C)%h,O,A,T,(C+W)%h end;E[1]=(E[1]+T)%h;E[2]=(E[2]+A)%h
E[3]=(E[3]+O)%h;E[4]=(E[4]+I)%h;E[5]=(E[5]+N)%h
E[6]=(E[6]+S)%h;E[7]=(E[7]+H)%h;E[8]=(E[8]+R)%h;return E end
local function q(_,E)local T={}for A=1,E do T[(A-1)*4+1]=r(w(_[A],24),0xFF)
T[(A-1)*4+2]=r(w(_[A],16),0xFF)T[(A-1)*4+3]=r(w(_[A],8),0xFF)
T[(A-1)*4+4]=r(_[A],0xFF)end;return
setmetatable(T,m)end
local function j(_)_=_ or""_=type(_)=="table"and{c(_)}or
{tostring(_):byte(1,-1)}_=g(_)local E={c(y)}for T=1,#_ do
E=k(_[T],E)end;return q(E,8)end
local function x(_,E)_=type(_)=="table"and{c(_)}or
{tostring(_):byte(1,-1)}
E=type(E)=="table"and
{c(E)}or{tostring(E):byte(1,-1)}local T=64;E=#E>T and j(E)or E;local A={}local O={}local I={}for N=1,T do
A[N]=l(0x36,E[N]or 0)O[N]=l(0x5C,E[N]or 0)end;for N=1,#_ do
A[T+N]=_[N]end;A=j(A)for N=1,T do I[N]=O[N]I[T+N]=A[N]end;return j(I)end
local function z(_,E,T,A)
E=type(E)=="table"and E or{tostring(E):byte(1,-1)}local O=32;A=A or 32;local I=1;local N={}
while A>0 do local S={}local H={c(E)}local R=A>O and O or A;H[#
H+1]=r(w(I,24),0xFF)H[#H+1]=r(w(I,16),0xFF)
H[#H+1]=r(w(I,8),0xFF)H[#H+1]=r(I,0xFF)
for D=1,T do H=x(H,_)
for L=1,R do S[L]=l(H[L],S[L]or 0)end;if D%200 ==0 then os.queueEvent("PBKDF2",D)
coroutine.yield("PBKDF2")end end;A=A-R;I=I+1;for D=1,R do N[#N+1]=S[D]end end;return setmetatable(N,m)end;return{digest=j,hmac=x,pbkdf2=z}end
a["ecnet.symmetric.random"]=function(...)local n=i("ecnet.symmetric.sha256")
local s=""local h=""local r="/.random"local function d(p)h=h.. (p or"")end;local function l()
s=tostring(n.digest(s..h))h=""end;if fs.exists(r)then local p=fs.open(r,"rb")
d(p.readAll())p.close()end;local u=os.epoch("utc")
local c=u;local m=1;d("init")
d(tostring(math.random(1,2^31-1)))d("|")
d(tostring(math.random(1,2^31-1)))d("|")
d(tostring(math.random(1,2^4)))d("|")d(tostring(u))d("|")
while(c-u<500)or(m<10000)do
c=os.epoch("utc")local p=tostring({}):sub(8)while#p<8 do p="0"..p end;d(string.char(
c%256))
d(string.char(tonumber(p:sub(1,2),16)))
d(string.char(tonumber(p:sub(3,4),16)))
d(string.char(tonumber(p:sub(5,6),16)))
d(string.char(tonumber(p:sub(7,8),16)))m=m+1 end;l()d(tostring(os.epoch("utc")))l()
local function f()
d("save")d(tostring(os.epoch("utc")))
d(tostring({}))l()local p=fs.open(r,"wb")
p.write(tostring(n.hmac("save",s)))s=tostring(n.digest(s))p.close()end;f()
local function w(p)d("seed")
d(tostring(os.epoch("utc")))d(tostring({}))d(p)l()f()end;local function y()d("random")
d(tostring(os.epoch("utc")))d(tostring({}))l()f()local p=n.hmac("out",s)
s=tostring(n.digest(s))return p end;return
{seed=w,save=f,random=y}end
a["ecnet.symmetric.chacha20"]=function(...)local n=i("ecnet.util")local s=bit32.bxor
local h=bit32.band;local r=bit32.lshift;local d=bit32.arshift;local l=_G.textutils;local u=n.byteTableMT
local c=2^32
local m={("expand 16-byte k"):byte(1,-1)}
local f={("expand 32-byte k"):byte(1,-1)}
local function w(q,j)local x=q/ (2^ (32-j))local z=x%1;return(x-z)+z*c end
local function y(q,j,x,z,_)q[j]=(q[j]+q[x])%c;q[_]=w(s(q[_],q[j]),16)q[z]=(
q[z]+q[_])%c;q[x]=w(s(q[x],q[z]),12)q[j]=(q[j]+
q[x])%c;q[_]=w(s(q[_],q[j]),8)q[z]=
(q[z]+q[_])%c;q[x]=w(s(q[x],q[z]),7)return q end
local function p(q,j)local x={table.unpack(q)}
for z=1,j do local _=z%2 ==1;x=_ and y(x,1,5,9,13)or
y(x,1,6,11,16)
x=_ and y(x,2,6,10,14)or y(x,2,7,12,13)x=_ and y(x,3,7,11,15)or y(x,3,8,9,14)x=_ and
y(x,4,8,12,16)or y(x,4,5,10,15)end;for z=1,16 do x[z]=(x[z]+q[z])%c end;return x end
local function v(q,j)return
(q[j+1]or 0)+r((q[j+2]or 0),8)+
r((q[j+3]or 0),16)+r((q[j+4]or 0),24)end
local function b(q,j,x)local z=#q==32;local _=z and f or m;local E={}E[1]=v(_,0)E[2]=v(_,4)
E[3]=v(_,8)E[4]=v(_,12)E[5]=v(q,0)E[6]=v(q,4)E[7]=v(q,8)E[8]=v(q,12)E[9]=v(q,
z and 16 or 0)E[10]=v(q,z and 20 or 4)E[11]=v(q,
z and 24 or 8)E[12]=v(q,z and 28 or 12)
E[13]=x;E[14]=v(j,0)E[15]=v(j,4)E[16]=v(j,8)return E end
local function g(q)local j={}for x=1,16 do j[#j+1]=h(q[x],0xFF)
j[#j+1]=h(d(q[x],8),0xFF)j[#j+1]=h(d(q[x],16),0xFF)
j[#j+1]=h(d(q[x],24),0xFF)end;return j end
local function k(q,j,x,z,_)
assert(type(j)=="table","ChaCha20: Invalid key format ("..type(j).."), must be table")
assert(type(x)=="table","ChaCha20: Invalid nonce format ("..type(x).."), must be table")
assert(#j==16 or#j==32,"ChaCha20: Invalid key length ("..#j.."), must be 16 or 32")
assert(#x==12,"ChaCha20: Invalid nonce length ("..#x.."), must be 12")
q=type(q)=="table"and{table.unpack(q)}or{tostring(q):byte(1,
-1)}z=tonumber(z)or 1;_=tonumber(_)or 20;local E={}
local T=b(j,x,z)local A=math.floor(#q/64)
for O=0,A do local I=g(p(T,_))
T[13]=(T[13]+1)%c;local N={}for S=1,64 do N[S]=q[((O)*64)+S]end;for S=1,#N do
E[#E+1]=s(N[S],I[S])end;if O%1000 ==0 then os.queueEvent("")
os.pullEvent("")end end;return setmetatable(E,u)end;return{crypt=k}end
a["ecnet.symmetric.aecrypt"]=function(...)local n=i("ecnet.symmetric.chacha20")
local s=i("ecnet.symmetric.sha256")local h=i("ecnet.symmetric.siphash")
local r=i("ecnet.symmetric.random")local d=i("ecnet.util")local l=d.byteTableMT
local function u()local f={}
local w=os.epoch("utc")for y=1,7 do f[#f+1]=w%256;w=w/256;w=w-w%1 end;for y=8,12 do
f[y]=math.random(0,255)end;return f end
local function c(f,w,y)local p=u()local v=n.crypt(f,w,p,1,8)local b=p;for k=1,#v do b[#b+1]=v[k]end
local g=h.mac(b,{unpack(y,1,16)})for k=1,#g do b[#b+1]=g[k]end;return setmetatable(b,l)end
local function m(f,w,y)local f=type(f)=="table"and{unpack(f)}or
{tostring(f):byte(1,-1)}
local p=h.mac({unpack(f,1,#f-8)},{unpack(y,1,16)})local v={unpack(f,#f-7)}local b={unpack(f,13,#f-8)}
assert(p:isEqual(v),"invalid mac")local g={unpack(f,1,12)}local k=n.crypt(b,w,g,1,8)return
setmetatable(k,l)end;return{encrypt=c,decrypt=m}end
a["ecnet.ecnet"]=function(...)local n=i("ecnet.util")local s=i("ecnet.cbor")
local h=i("ecnet.symmetric.sha256")local r=i("ecnet.symmetric.chacha20")
local d=i("ecnet.symmetric.siphash")local l=i("ecnet.symmetric.aecrypt")
local u=i("ecnet.symmetric.random")local c=i("ecnet.ecc.ecc")local m=33635;local f="/.ecnet-secretseed"
local w=os.epoch("utc")local y={}local p=false
local function v(L)local U=h.digest(L)local C=U:toHex()local M=""
M=M..C:sub(1,4)M=M..":"M=M..C:sub(5,8)M=M..":"M=M..C:sub(9,12)
M=M..":"M=M..C:sub(13,16)M=M..":"M=M..C:sub(17,20)return M end;if not fs.exists(f)then local L=u.random()
L=string.char(unpack(L))n.saveFile(f,L)end
local b=n.loadFile(f)local g,k=c.keypair(b)local q=v(k)
local function j(L,U)
local C={type="addressRequest",from=q,to=U}L.transmit(m,m,C)local M={otherAddress=U}return M end
local function x(L,U)local C=v(U)local M
if y[C]then M=y[C].sharedSecret else M=c.exchange(g,U)end;local F,W=c.keypair()local Y=h.hmac("senderTagKey",M)
local P=os.epoch("utc")local V=h.hmac(tostring(W)..tostring(P),Y)
local B={type="connectionRequest",from=q,to=C,publicKey=tostring(k),ephemeralPublicKey=tostring(W),tag=tostring(V):sub(1,10),counter=P}L.transmit(m,m,B)
local G={ephemeralSecretKey=tostring(F),sharedSecret=M,otherAddress=C}return G end
local function z(L,U)local C=U.from
local M={type="addressResponse",from=q,to=C,publicKey=tostring(k)}L.transmit(m,m,M)end
local function _(L,U)local C=U.from;local M=U.publicKey;assert(L.otherAddress==C)assert(
type(M)=="string"and#M==22)
assert(v(M)==C)return M end
local function E(L,U)local C=U.publicKey;local M=U.ephemeralPublicKey;local F=U.from;local W=U.tag;local Y=U.counter;assert(
type(C)=="string"and#C==22)assert(
type(M)=="string")assert(#M==22)
assert(v(C)==F)assert(type(W)=="string"and#W==10)assert(
type(Y)=="number")if y[F]then
assert(Y>y[F].counter)else assert(Y>w)end;local P;if y[F]then P=y[F].sharedSecret else
P=c.exchange(g,C)end;local V,B=c.keypair()local G=c.exchange(V,M)
local K=h.hmac(G,P)local Q=h.hmac("senderEncryptionKey",K)
local J={unpack(h.hmac("senderMacKey",K),1,16)}local X=h.hmac("receiverEncryptionKey",K)
local Z={unpack(h.hmac("receiverMacKey",K),1,16)}local ee=h.hmac("senderTagKey",P)
local et=h.hmac("receiverTagKey",K)
assert(
tostring(h.hmac(M..tostring(Y),ee)):sub(1,10)==W)local Y=os.epoch("utc")
local ea=h.hmac(tostring(B)..tostring(Y),et)
local eo={type="connectionResponse",from=q,to=F,publicKey=tostring(k),ephemeralPublicKey=tostring(B),tag=tostring(ea):sub(1,10),counter=Y}L.transmit(m,m,eo)
y[F]={publicKey=C,sharedSecret=P,ownEncryptionKey=X,ownMacKey=Z,otherEncryptionKey=Q,otherMacKey=J,counter=Y}end
local function T(L,U)local C=U.publicKey;local M=U.ephemeralPublicKey;local F=U.from;local W=U.tag;local Y=U.counter;assert(
L.otherAddress==F)
assert(type(C)=="string"and#C==22)assert(type(M)=="string")assert(#M==22)assert(v(C)==
F)
assert(type(W)=="string"and#W==10)assert(type(Y)=="number")local P=L.ephemeralSecretKey
local V=L.sharedSecret;local B=c.exchange(P,M)local G=h.hmac(B,V)
local K=h.hmac("senderEncryptionKey",G)
local Q={unpack(h.hmac("senderMacKey",G),1,16)}local J=h.hmac("receiverEncryptionKey",G)
local X={unpack(h.hmac("receiverMacKey",G),1,16)}local Z=h.hmac("receiverTagKey",G)
assert(
tostring(h.hmac(M..tostring(Y),Z)):sub(1,10)==W)
y[F]={publicKey=C,sharedSecret=V,ownEncryptionKey=K,ownMacKey=Q,otherEncryptionKey=J,otherMacKey=X,counter=Y}end
local function A(L)local U=L.ciphertext;local C=L.from;local M=L.counter;local F=y[C].counter
assert(type(U)=="string")assert(type(C)=="string")
assert(type(M)=="number")assert(y[C])assert(M>F)local W=y[C].otherEncryptionKey
local Y=y[C].otherMacKey;local P=l.decrypt(U,W,Y)P=tostring(P)local V=0;for Q=1,6 do V=V*256
V=V+P:byte(7-Q)end;local B=P:byte(7)
local G=#P-7- ((-B-1)%256)local K=P:sub(8,G+7)K=s.decode(K)assert(V>F)y[C].counter=V
return C,K end
local function O(L)local U;local C={L}local M=false;local F,W,Y
while true do
if not M then if#C>0 then W=table.remove(C,1)
U=coroutine.create(A)M=true end end
if M then F,W,Y=coroutine.resume(U,W)if
coroutine.status(U)=="dead"then if F then os.queueEvent("ecnet_message",W,Y)end
M=false end end;C[#C+1]=coroutine.yield()end end;local I=coroutine.wrap(O)
local function N(L)
while true do
while true do local U,C,M,C,F=os.pullEvent()if
U~="modem_message"then I()end;if M~=m then break end;if type(F)~="table"then break end;if F.to~=
q then break end
if F.type=="addressRequest"then pcall(z,L,F)elseif
F.type=="connectionRequest"then local W=pcall(E,L,F)if W then
os.queueEvent("ecnet_connection",F.from)end elseif F.type=="message"then I(F)end end end end
local function S(L,U,C)
local M=parallel.waitForAny(function()sleep(C)end,function()local F
if y[U]then F=y[U].publicKey else local Y=j(L,U)
while true do
local P,P,V,P,B=os.pullEvent("modem_message")
if
(
V==m and type(B)=="table"and B.to==q and B.from==U and B.type=="addressResponse")then local G;G,F=pcall(_,Y,B)if G then break end end end end;local W=x(L,F)
while true do local Y,Y,P,Y,V=os.pullEvent("modem_message")
if
(
P==m and type(V)==
"table"and V.to==q and V.from==U and V.type=="connectionResponse")then local B=pcall(T,W,V)if B then break end end end end,N)return(M==2)end
local function H(L,U,C)if not y[U]then return false end;local M=y[U].ownEncryptionKey
local F=y[U].ownMacKey;C=s.encode(C)local W=os.epoch("utc")local Y=W;local P=""
for G=1,6 do P=P..
string.char(Y%256)Y=math.floor(Y/256)end;P=P..string.char(#C%256)P=P..C;P=P.. ("\0"):rep((-#C-1)%
256)local V=l.encrypt(P,M,F)
local B={type="message",from=q,to=U,ciphertext=tostring(V),counter=W}L.transmit(m,m,B)return true end
local function R(L,U,C)local M,F
local W=parallel.waitForAny(function()if C then sleep(C)else
while true do coroutine.yield()end end end,function()
while true do local Y
Y,M,F=os.pullEvent("ecnet_message")if not U or M==U then return end end end,function()N(L)end)if W==2 then return M,F else return nil end end
local function D(L)L.open(m)
return
{listen=function()return N(L)end,connect=function(U,C)return S(L,U,C)end,send=function(U,C)
return H(L,U,C)end,receive=function(U,C)return R(L,U,C)end}end;return{wrap=D,address=q}end
a["ecnet.ecc.modq"]=function(...)local n=i("ecnet.util")
local s=i("ecnet.ecc.arith")local h=i("ecnet.symmetric.sha256")
local r=i("ecnet.symmetric.random")local d=s.isEqual;local l=s.compare;local u=s.add;local c=s.sub;local m=s.addDouble;local f=s.mult
local w=s.square;local y=s.encodeInt;local p=s.decodeInt;local v=n.byteTableMT;local b
local g={9622359,6699217,13940450,16775734,16777215,16777215,3940351}
local k={1,0,1,0,1,0,1,0,1,1,0,0,1,0,1,1,0,1,0,0,1,0,0,1,1,0,0,0,1,0,1,1,0,0,0,1,1,1,0,0,0,1,1,0,0,1,1,0,0,1,0,0,0,1,1,1,0,1,1,0,1,1,0,1,0,0,1,0,1,0,1,1,0,1,1,0,1,1,0,0,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1}
local q={15218585,5740955,3271338,9903997,9067368,7173545,6988392}
local j={1336213,11071705,9716828,11083885,9188643,1494868,3306114}local function x(C)local M={unpack(C)}if l(M,g)>=0 then M=c(M,g)end
return setmetatable(M,b)end
local function z(C,M)return x(u(C,M))end
local function _(C,M)local F=c(C,M)if F[7]<0 then F=u(F,g)end;return setmetatable(F,b)end
local function E(C)
local M={unpack(f({unpack(C,1,7)},q,true),1,7)}local F={unpack(m(C,f(M,g)),8,14)}return x(F)end;local function T(C,M)return E(f(C,M))end;local function A(C)return E(w(C))end;local function O(C)
return T(C,j)end
local function I(C)local C={unpack(C)}for M=8,14 do C[M]=0 end;return E(C)end;local N=O({1,0,0,0,0,0,0})
local function S(C,M)local C={unpack(C)}
local F={unpack(N)}for W=1,168 do if M[W]==1 then F=T(F,C)end;C=A(C)end;return F end
local function H(C,M)local C={unpack(C)}local F=setmetatable({unpack(N)},b)if
M<0 then C=S(C,k)M=-M end;while M>0 do if M%2 ==1 then F=T(F,C)end;C=A(C)M=M/2
M=M-M%1 end;return F end;local function R(C)local M=y(C)return setmetatable(M,v)end
local function D(C)C=type(C)==
"table"and{unpack(C,1,21)}or
{tostring(C):byte(1,21)}local M=p(C)M[7]=
M[7]%g[7]return setmetatable(M,b)end;local function L()
while true do local C={unpack(r.random(),1,21)}local M=p(C)if
M[7]<g[7]then return setmetatable(M,b)end end end;local function U(C)return
D(h.digest(C))end
b={__index={encode=function(C)return R(C)end},__tostring=function(C)return
C:encode():toHex()end,__add=function(C,M)
if type(C)=="number"then return M+C end;if type(M)=="number"then
assert(M<2^24,"number operand too big")M=O({M,0,0,0,0,0,0})end;return
z(C,M)end,__sub=function(C,M)if
type(C)=="number"then assert(C<2^24,"number operand too big")
C=O({C,0,0,0,0,0,0})end;if type(M)=="number"then
assert(M<2^24,"number operand too big")M=O({M,0,0,0,0,0,0})end;return
_(C,M)end,__unm=function(C)return
_(g,C)end,__eq=function(C,M)return d(C,M)end,__mul=function(C,M)
if type(C)=="number"then return M*C end
if type(M)=="table"and type(M[1])=="table"then return M*C end;if type(M)=="number"then
assert(M<2^24,"number operand too big")M=O({M,0,0,0,0,0,0})end;return
T(C,M)end,__div=function(C,M)if
type(C)=="number"then assert(C<2^24,"number operand too big")
C=O({C,0,0,0,0,0,0})end;if type(M)=="number"then
assert(M<2^24,"number operand too big")M=O({M,0,0,0,0,0,0})end
local F=S(M,k)return T(C,F)end,__pow=function(C,M)return
H(C,M)end}return{hashModQ=U,randomModQ=L,decodeModQ=D,inverseMontgomeryModQ=I}end
a["ecnet.ecc.modp"]=function(...)local n=i("ecnet.ecc.arith")local s=n.add;local h=n.sub
local r=n.addDouble;local d=n.mult;local l=n.square;local u={3,0,0,0,0,0,15761408}
local c={5592405,5592405,5592405,5592405,5592405,5592405,14800213}
local m={13533400,837116,6278376,13533388,837116,6278376,7504076}
local function f(z)local _,E,T,A,O,I,N=unpack(z)local S=_*3;local H=E*3;local R=T*3;local D=A*3;local L=O*3;local U=I*3
local C=_*15761408;C=C+N*3;local M=E*15761408;local F=T*15761408;local W=A*15761408
local Y=O*15761408;local P=I*15761408;local V=N*15761408;local B=0;local G;G=S/0x1000000
H=H+ (G-G%1)S=S%0x1000000;G=H/0x1000000;R=R+ (G-G%1)H=H%0x1000000;G=R/
0x1000000;D=D+ (G-G%1)R=R%0x1000000;G=D/0x1000000;L=L+
(G-G%1)D=D%0x1000000;G=L/0x1000000;U=U+ (G-G%1)
L=L%0x1000000;G=U/0x1000000;C=C+ (G-G%1)U=U%0x1000000;G=C/0x1000000;M=M+ (G-
G%1)C=C%0x1000000;G=M/0x1000000
F=F+ (G-G%1)M=M%0x1000000;G=F/0x1000000;W=W+ (G-G%1)F=F%0x1000000;G=W/
0x1000000;Y=Y+ (G-G%1)W=W%0x1000000;G=Y/0x1000000;P=P+
(G-G%1)Y=Y%0x1000000;G=P/0x1000000;V=V+ (G-G%1)
P=P%0x1000000;G=V/0x1000000;B=B+ (G-G%1)V=V%0x1000000;return
{S,H,R,D,L,U,C,M,F,W,Y,P,V,B}end
local function w(z)if z[7]<15761408 or z[7]==15761408 and z[1]<3 then return
{unpack(z)}end;local _=z[1]local E=z[2]local T=z[3]
local A=z[4]local O=z[5]local I=z[6]local N=z[7]_=_-3;N=N-15761408
if _<0 then E=E-1;_=_+0x1000000 end;if E<0 then T=T-1;E=E+0x1000000 end
if T<0 then A=A-1;T=T+0x1000000 end;if A<0 then O=O-1;A=A+0x1000000 end
if O<0 then I=I-1;O=O+0x1000000 end;if I<0 then N=N-1;I=I+0x1000000 end;return{_,E,T,A,O,I,N}end;local function y(z,_)return w(s(z,_))end;local function p(z,_)local E=h(z,_)
if E[7]<0 then E=s(E,u)end;return E end;local function v(z)local _=d(z,c,true)
local E={unpack(r(z,f(_)),8,14)}return w(E)end
local function b(z,_)return v(d(z,_))end;local function g(z)return v(l(z))end;local function k(z)return b(z,m)end;local function q(z)
local z={unpack(z)}for _=8,14 do z[_]=0 end;return v(z)end
local j=k({1,0,0,0,0,0,0})
local function x(z,_)local z={unpack(z)}local E={unpack(j)}for T=1,168 do
if _[T]==1 then E=b(E,z)end;z=g(z)end;return E end
return{addModP=y,subModP=p,multModP=b,squareModP=g,montgomeryModP=k,inverseMontgomeryModP=q,expModP=x}end
a["ecnet.ecc.ecc"]=function(...)local n=i("ecnet.util")
local s=i("ecnet.ecc.curve")local h=i("ecnet.ecc.modq")local r=i("ecnet.symmetric.sha256")
local d=i("ecnet.symmetric.chacha20")local l=i("ecnet.symmetric.siphash")
local u=i("ecnet.symmetric.random")local c=n.byteTableMT
local function m(p)local v
if p then v=h.hashModQ(p)else v=h.randomModQ()end;local b=s.G*v;local g=v:encode()local k=b:encode()return g,k end;local function f(p,v)local b=h.decodeModQ(p)local g=s.pointDecode(v)local k=g*b
local q=r.digest(k:encode())return q end
local function w(p,v)
local v=
type(v)=="table"and string.char(unpack(v))or tostring(v)local p=type(p)=="table"and string.char(unpack(p))or
tostring(p)
local b=h.decodeModQ(p)local g=h.randomModQ()local k=s.G*g
local q=h.hashModQ(v..tostring(k))local j=g-b*q;q=q:encode()j=j:encode()local x=q
for z=1,#j do x[#x+1]=j[z]end;return setmetatable(x,c)end
local function y(p,v,b)local v=type(v)=="table"and string.char(unpack(v))or
tostring(v)
local g=s.pointDecode(p)local k=h.decodeModQ({unpack(b,1,#b/2)})local q=h.decodeModQ({unpack(b,
#b/2+1)})
local j=s.G*q+g*k;local x=h.hashModQ(v..tostring(j))return x==k end;return{keypair=m,exchange=f,sign=w,verify=y}end
a["ecnet.ecc.curve"]=function(...)local n=i("ecnet.util")
local s=i("ecnet.ecc.arith")local h=i("ecnet.ecc.modp")local r=i("ecnet.ecc.modq")
local l=s.isEqual;local u=s.NAF;local c=s.encodeInt;local m=s.decodeInt;local f=h.multModP;local w=h.squareModP
local y=h.addModP;local v=h.subModP;local b=h.montgomeryModP;local g=h.expModP;local k=r.inverseMontgomeryModQ
local q=n.byteTableMT;local j;local x={0,0,0,0,0,0,0}local z=b({1,0,0,0,0,0,0})
local _=b({122,0,0,0,0,0,0})local E={3,0,0,0,0,0,15761408}
local T={1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,1,1}
local A={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,1,1}
local I={{6636044,10381432,15741790,2914241,5785600,264923,4550291},{13512827,8449886,5647959,1135556,5489843,7177356,8002203},{unpack(z)}}
local N={{unpack(x)},{unpack(z)},{unpack(z)}}
local function S(d)local p,O,G=unpack(d)local K=y(p,O)local Q=w(K)local X=w(p)local Z=w(O)local ee=y(X,Z)
local et=w(G)local ea=v(ee,y(et,et))local eo=f(v(Q,ee),ea)local ei=f(ee,v(X,Z))
local en=f(ee,ea)local es={eo,ei,en}return setmetatable(es,j)end
local function H(d,p)local O,G,K=unpack(d)local Q,J,X=unpack(p)local Z=f(K,X)local ee=w(Z)local et=f(O,Q)
local ea=f(G,J)local eo=f(_,f(et,ea))local ei=v(ee,eo)local I=y(ee,eo)
local en=f(Z,f(ei,v(f(y(O,G),y(Q,J)),y(et,ea))))local es=f(Z,f(I,v(ea,et)))local eh=f(ei,I)local er={en,es,eh}return
setmetatable(er,j)end
local function R(d)local p,O,B=unpack(d)local G=v(x,p)local K={unpack(O)}
local Q={unpack(B)}local J={G,K,Q}return setmetatable(J,j)end;local function D(d,p)return H(d,R(p))end
local function L(d)local p,O,B=unpack(d)local G=g(B,T)
local K=f(p,G)local Q=f(O,G)local J={unpack(z)}local X={K,Q,J}return setmetatable(X,j)end
local function U(d,p)local O,B,G=unpack(d)local K,Q,J=unpack(p)local X=f(O,J)local Z=f(B,J)local ee=f(K,G)
local et=f(Q,G)return l(X,ee)and l(Z,et)end
local function C(d)local p,O,B=unpack(d)local G=w(p)local K=w(O)local Q=w(B)local J=w(Q)local X=y(G,K)X=f(X,Q)
local Z=f(_,f(G,K))Z=y(J,Z)return l(X,Z)end;local function M(d)return l(d[1],x)end
local function F(d,p)local O=u(d,5)local B={p}local G=S(p)
local K={{unpack(x)},{unpack(z)},{unpack(z)}}for Q=3,31,2 do B[Q]=H(B[Q-2],G)end
for Q=#O,1,-1 do K=S(K)if O[Q]>0 then
K=H(K,B[O[Q]])elseif O[Q]<0 then K=D(K,B[-O[Q]])end end;return setmetatable(K,j)end;local W={I}for d=2,168 do W[d]=S(W[d-1])end
local function Y(d)local p=u(d,2)
local O={{unpack(x)},{unpack(z)},{unpack(z)}}for B=1,168 do
if p[B]==1 then O=H(O,W[B])elseif p[B]==-1 then O=D(O,W[B])end end;return setmetatable(O,j)end;local function P(d)d=L(d)local p={}local O,B=unpack(d)p=c(B)p[22]=O[1]%2
return setmetatable(p,q)end
local function V(d)
d=type(d)=="table"and
{unpack(d,1,22)}or{tostring(d):byte(1,22)}local p=m(d)p[7]=p[7]%E[7]local O=w(p)local B=v(O,z)local G=v(f(_,O),z)
local K=w(B)local Q=f(B,K)local J=f(Q,K)local X=f(G,w(G))local Z=f(J,X)
local ee=f(Q,f(G,g(Z,A)))if ee[1]%2 ~=d[22]then ee=v(x,ee)end
local et={ee,p,{unpack(z)}}return setmetatable(et,j)end
j={__index={isOnCurve=function(d)return C(d)end,isInf=function(d)return d:isOnCurve()and M(d)end,encode=function(d)return
P(d)end},__tostring=function(d)return
d:encode():toHex()end,__add=function(d,p)
assert(d:isOnCurve(),"invalid point")assert(p:isOnCurve(),"invalid point")return H(d,p)end,__sub=function(d,p)
assert(d:isOnCurve(),"invalid point")assert(p:isOnCurve(),"invalid point")return D(d,p)end,__unm=function(d)
assert(d:isOnCurve(),"invalid point")return R(d)end,__eq=function(d,p)
assert(d:isOnCurve(),"invalid point")assert(p:isOnCurve(),"invalid point")return U(d,p)end,__mul=function(d,p)if
type(d)=="number"then return p*d end
if type(p)=="number"then
assert(p<2^24,"number multiplier too big")p={p,0,0,0,0,0,0}else p=k(p)end;if d==I then return Y(p)else return F(p,d)end end}I=setmetatable(I,j)N=setmetatable(N,j)
return{G=I,O=N,pointDecode=V}end
a["ecnet.ecc.arith"]=function(...)
local function n(p,v)return
(

p[1]==v[1]and p[2]==v[2]and p[3]==v[3]and p[4]==v[4]and p[5]==v[5]and p[6]==v[6]and p[7]==v[7])end;local function s(p,v)
for b=7,1,-1 do if p[b]>v[b]then return 1 elseif p[b]<v[b]then return-1 end end;return 0 end
local function h(p,v)
local b=p[1]+v[1]local g=p[2]+v[2]local k=p[3]+v[3]local q=p[4]+v[4]
local j=p[5]+v[5]local x=p[6]+v[6]local z=p[7]+v[7]
if b>0xffffff then g=g+1;b=b-0x1000000 end;if g>0xffffff then k=k+1;g=g-0x1000000 end;if k>0xffffff then q=q+1
k=k-0x1000000 end;if q>0xffffff then j=j+1;q=q-0x1000000 end;if j>
0xffffff then x=x+1;j=j-0x1000000 end;if x>0xffffff then z=z+1
x=x-0x1000000 end;return{b,g,k,q,j,x,z}end
local function r(p,v)local b=p[1]-v[1]local g=p[2]-v[2]local k=p[3]-v[3]
local q=p[4]-v[4]local j=p[5]-v[5]local x=p[6]-v[6]local z=p[7]-v[7]if b<0 then g=g-1
b=b+0x1000000 end;if g<0 then k=k-1;g=g+0x1000000 end;if k<0 then q=q-1
k=k+0x1000000 end;if q<0 then j=j-1;q=q+0x1000000 end;if j<0 then x=x-1
j=j+0x1000000 end;if x<0 then z=z-1;x=x+0x1000000 end
return{b,g,k,q,j,x,z}end
local function d(p)local v=p[1]local b=p[2]local g=p[3]local k=p[4]local q=p[5]local j=p[6]local x=p[7]v=v/2
v=v-v%1;v=v+ (b%2)*0x800000;b=b/2;b=b-b%1
b=b+ (g%2)*0x800000;g=g/2;g=g-g%1;g=g+ (k%2)*0x800000;k=k/2;k=k-k%1;k=k+
(q%2)*0x800000;q=q/2;q=q-q%1;q=q+ (j%2)*0x800000;j=j/2;j=j-j%
1;j=j+ (x%2)*0x800000;x=x/2;x=x-x%1
return{v,b,g,k,q,j,x}end
local function l(p,v)local b=p[1]+v[1]local g=p[2]+v[2]local k=p[3]+v[3]
local q=p[4]+v[4]local j=p[5]+v[5]local x=p[6]+v[6]local z=p[7]+v[7]
local _=p[8]+v[8]local E=p[9]+v[9]local T=p[10]+v[10]local A=p[11]+v[11]
local O=p[12]+v[12]local I=p[13]+v[13]local N=p[14]+v[14]if b>0xffffff then g=g+1
b=b-0x1000000 end;if g>0xffffff then k=k+1;g=g-0x1000000 end;if k>
0xffffff then q=q+1;k=k-0x1000000 end;if q>0xffffff then j=j+1
q=q-0x1000000 end;if j>0xffffff then x=x+1;j=j-0x1000000 end;if x>
0xffffff then z=z+1;x=x-0x1000000 end;if z>0xffffff then _=_+1
z=z-0x1000000 end;if _>0xffffff then E=E+1;_=_-0x1000000 end;if E>
0xffffff then T=T+1;E=E-0x1000000 end;if T>0xffffff then A=A+1
T=T-0x1000000 end;if A>0xffffff then O=O+1;A=A-0x1000000 end;if O>
0xffffff then I=I+1;O=O-0x1000000 end;if I>0xffffff then N=N+1
I=I-0x1000000 end;return{b,g,k,q,j,x,z,_,E,T,A,O,I,N}end
local function u(p,v,b)local g,k,q,j,x,z,_=unpack(p)local E,T,A,O,I,N,S=unpack(v)local H=g*E;local R=g*T+k*E;local D=
g*A+k*T+q*E;local L=g*O+k*A+q*T+j*E;local U=g*I+k*O+q*A+
j*T+x*E;local C=g*N+k*I+q*O+j*A+x*T+
z*E;local M=
g*S+k*N+q*I+j*O+x*A+z*T+_*E;local F,W,Y,P,V,B,G;if not b then F=k*S+q*N+j*I+x*O+
z*A+_*T
W=q*S+j*N+x*I+z*O+_*A;Y=j*S+x*N+z*I+_*O;P=x*S+z*N+_*I;V=z*S+_*N
B=_*S;G=0 else F=0 end;local K;K=H;H=
H%0x1000000;R=R+ (K-H)/0x1000000;K=R;R=R%0x1000000;D=
D+ (K-R)/0x1000000;K=D;D=D%0x1000000
L=L+ (K-D)/0x1000000;K=L;L=L%0x1000000;U=U+ (K-L)/0x1000000;K=U
U=U%0x1000000;C=C+ (K-U)/0x1000000;K=C;C=C%0x1000000
M=M+ (K-C)/0x1000000;K=M;M=M%0x1000000
if not b then F=F+ (K-M)/0x1000000;K=F
F=F%0x1000000;W=W+ (K-F)/0x1000000;K=W;W=W%0x1000000
Y=Y+ (K-W)/0x1000000;K=Y;Y=Y%0x1000000;P=P+ (K-Y)/0x1000000;K=P
P=P%0x1000000;V=V+ (K-P)/0x1000000;K=V;V=V%0x1000000
B=B+ (K-V)/0x1000000;K=B;B=B%0x1000000;G=G+ (K-B)/0x1000000 end;return{H,R,D,L,U,C,M,F,W,Y,P,V,B,G}end
local function c(p)local v,b,g,k,q,j,x=unpack(p)local z=v*v;local _=v*b*2;local E=v*g*2+b*b
local T=v*k*2+b*g*2;local A=v*q*2+b*k*2+g*g
local O=v*j*2+b*q*2+g*k*2;local I=v*x*2+b*j*2+g*q*2+k*k;local N=b*x*2+g*j*2+k*
q*2;local S=g*x*2+k*j*2+q*q;local H=k*x*2+
q*j*2;local R=q*x*2+j*j;local D=j*x*2;local L=x*x;local U=0;local C;C=z
z=z%0x1000000;_=_+ (C-z)/0x1000000;C=_;_=_%0x1000000
E=E+ (C-_)/0x1000000;C=E;E=E%0x1000000;T=T+ (C-E)/0x1000000;C=T
T=T%0x1000000;A=A+ (C-T)/0x1000000;C=A;A=A%0x1000000
O=O+ (C-A)/0x1000000;C=O;O=O%0x1000000;I=I+ (C-O)/0x1000000;C=I
I=I%0x1000000;N=N+ (C-I)/0x1000000;C=N;N=N%0x1000000
S=S+ (C-N)/0x1000000;C=S;S=S%0x1000000;H=H+ (C-S)/0x1000000;C=H
H=H%0x1000000;R=R+ (C-H)/0x1000000;C=R;R=R%0x1000000
D=D+ (C-R)/0x1000000;C=D;D=D%0x1000000;L=L+ (C-D)/0x1000000;C=L
L=L%0x1000000;U=U+ (C-L)/0x1000000
return{z,_,E,T,A,O,I,N,S,H,R,D,L,U}end
local function m(p)local v={}for b=1,7 do local g=p[b]
for k=1,3 do v[#v+1]=g%256;g=math.floor(g/256)end end;return v end
local function f(p)local v={}local b={}
for g=1,21 do local k=p[g]
assert(type(k)=="number","integer decoding failure")
assert(k>=0 and k<=255,"integer decoding failure")assert(k%1 ==0,"integer decoding failure")b[g]=k end
for g=1,21,3 do local k=0;for q=2,0,-1 do k=k*256;k=k+b[g+q]end;v[#v+1]=k end;return v end
local function w(p,v)local b=p[1]%2^v;if b>=2^ (v-1)then b=b-2^v end;return b end
local function y(p,v)local b={}local p={unpack(p)}
for g=1,168 do if p[1]%2 ==1 then b[#b+1]=w(p,v)
p=r(p,{b[#b],0,0,0,0,0,0})else b[#b+1]=0 end;p=d(p)end;return b end
return{isEqual=n,compare=s,add=h,sub=r,addDouble=l,mult=u,square=c,encodeInt=m,decodeInt=f,NAF=y}end
a["ecnet.cbor"]=function(...)local function n(ed,el)local eu,ec=pcall(i,ed)if not eu then return end
if el then return ec[el]end;return ec end
local s=function(ed)
local el,eu=pcall(loadstring or load,ed)if el and eu then return eu()end end;local h=setmetatable;local r=getmetatable
local d=debug and debug.getmetatable;local l=assert;local u=error;local c=type;local m=pairs;local f=ipairs;local w=tostring
local y=string.char;local p=table.concat;local v=table.sort;local b=math.floor;local g=math.abs
local k=math.huge;local q=math.max;local j=math.maxinteger or 9007199254740992;local x=
math.mininteger or-9007199254740992;local z=0/0
local _=math.frexp
local E=math.ldexp or function(ed,el)return ed*2.0^el end
local T=math.type or function(ed)return
ed%1 ==0 and ed<=j and ed>=x and"integer"or"float"end;local A=string.pack or n("struct","pack")local O=string.unpack or
n("struct","unpack")
local I=
n("bit32","rshift")or n("bit","rshift")or s"return function(a,b) return a >> b end"or function(ed,el)return
q(0,b(ed/ (2^el)))end;if A and A(">I2",0)~="\0\0"then A=nil end;if O and
O(">I2","\1\2\3\4")~=0x102 then O=nil end;local N=nil;local S={}local function H(ed,el)return
S[c(ed)](ed,el)end
local function R(ed,el)
if el==0 and ed<0 then ed,el=-ed-1,32 end
if ed<24 then return y(el+ed)elseif ed<2^8 then return y(el+24,ed)elseif ed<2^16 then return
y(el+25,I(ed,8),ed%0x100)elseif ed<2^32 then return y(el+26,I(ed,24)%0x100,I(ed,16)%0x100,I(ed,8)%0x100,
ed%0x100)elseif ed<
2^64 then local eu=b(ed/2^32)ed=ed%2^32;return
y(el+27,I(eu,24)%0x100,I(eu,16)%0x100,
I(eu,8)%0x100,eu%0x100,I(ed,24)%0x100,I(ed,16)%0x100,I(ed,8)%0x100,ed%0x100)end;u"int too large"end
if A then
function R(ed,el)local eu;el=el or 0
if ed<24 then eu,el=">B",el+ed elseif ed<256 then eu,el=">BB",el+24 elseif ed<65536 then
eu,el=">BI2",el+25 elseif ed<4294967296 then eu,el=">BI4",el+26 else eu,el=">BI8",el+27 end;return A(eu,el,ed)end end;local D={}function D:__tostring()return
self.name or("simple(%d)"):format(self.value)end
function D:__tocbor()return
self.cbor or R(self.value,224)end
local function L(ed,el,eu)
l(ed>=0 and ed<=255,"bad argument #1 to 'simple' (integer in range 0..255 expected)")return h({value=ed,name=el,cbor=eu},D)end;local U={}function U:__tostring()
return("%d(%s)"):format(self.tag,w(self.value))end;function U:__tocbor()return
R(self.tag,192)..H(self.value)end
local function C(ed,el)
l(ed>=0,"bad argument #1 to 'tagged' (positive integer expected)")return h({tag=ed,value=el},U)end;local M=L(22,"null")local F=L(23,"undefined")
local W=L(31,"break","\255")function S.number(ed)return S[T(ed)](ed)end;function S.integer(ed)if ed<0 then
return R(-1-ed,32)end;return R(ed,0)end
function S.float(ed)if
ed~=ed then return"\251\127\255\255\255\255\255\255\255"end;local el=(
ed>0 or 1/ed>0)and 0 or 1
ed=g(ed)if ed==k then
return y(251,el*128+128-1).."\240\0\0\0\0\0\0"end;local eu,ec=_(ed)if eu==0 then return
y(251,el*128).."\0\0\0\0\0\0\0"end;eu=eu*2;ec=ec+1024-2;if
ec<=0 then eu=eu*2^ (ec-1)ec=0 else eu=eu-1 end
return
y(251,el*2^7+b(ec/
2^4)%2^7,ec%2^4*2^4+b(eu*2^4%0x100),b(
eu*2^12%0x100),b(eu*2^20%0x100),b(eu*2^28%0x100),b(
eu*2^36%0x100),b(eu*2^44%0x100),b(eu*2^52%0x100))end
if A then function S.float(ed)return A(">Bd",251,ed)end end;function S.bytestring(ed)return R(#ed,64)..ed end;function S.utf8string(ed)return
R(#ed,96)..ed end;S.string=S.bytestring;function S.boolean(ed)return
ed and"\245"or"\244"end
S["nil"]=function()return"\246"end;function S.userdata(ed,el)local eu=d(ed)if eu then local ec=el and el[eu]or eu.__tocbor;if ec then return
ec(ed,el)end end
u"can't encode userdata"end
function S.table(ed,el)
local eu=r(ed)if eu then local ep=el and el[eu]or eu.__tocbor
if ep then return ep(ed,el)end end
local ec,em,ef,ew={R(#ed,128)},{"\191"},1,2;local ey=true
for ep,ev in m(ed)do ey=ey and ef==ep;ef=ef+1;local eb=H(ev,el)ec[ef]=eb;em[ew],ew=H(ep,el),
ew+1;em[ew],ew=eb,ew+1 end;em[1]=R(ef-1,160)return p(ey and ec or em)end;function S.array(ed,el)local eu={}for ec,em in f(ed)do eu[ec]=H(em,el)end
return R(#eu,128)..p(eu)end
function S.map(ed,el)local eu,ec,em={"\191"},2,0
for ef,ew in
m(ed)do eu[ec],ec=H(ef,el),ec+1;eu[ec],ec=H(ew,el),ec+1;em=em+1 end;eu[1]=R(em,160)return p(eu)end;S.dict=S.map
function S.ordered_map(ed,el)local eu={}if not ed[1]then local ec=0
for em in m(ed)do ec=ec+1;eu[ec]=em end;v(eu)end;for ec,em in f(ed[1]and ed or eu)do eu[ec]=
H(em,el)..H(ed[em],el)end;return
R(#eu,160)..p(eu)end
S["function"]=function()u"can't encode function"end;local function Y(ed,el)return ed:read(el)end;local function P(ed)
return ed:read(1):byte()end
local function V(ed,el)
if el<24 then return el elseif el<28 then local eu=0;for ec=1,2^ (el-24)do
eu=eu*256+P(ed)end;return eu else u"invalid length"end end;local B={}local function G(ed)local el=P(ed)return I(el,5),el%32 end;local function K(ed,el)
local eu,ec=G(ed)return B[eu](ed,ec,el)end
local function Q(ed,el)return V(ed,el)end;local function J(ed,el)return-1-V(ed,el)end
local function X(ed,el)
if el~=31 then return Y(ed,V(ed,el))end;local eu={}local ec=1;local em=K(ed)
while em~=W do eu[ec],ec=em,ec+1;em=K(ed)end;return p(eu)end;local function Z(ed,el)return X(ed,el)end
local function ee(ed,el,eu)local ec={}
if el==31 then local em=1;local ef=K(ed,eu)while ef~=W do ec[em],em=ef,
em+1;ef=K(ed,eu)end else local em=V(ed,el)for ef=1,em do
ec[ef]=K(ed,eu)end end;return ec end
local function et(ed,el,eu)local ec={}local em
if el==31 then local ef=1;em=K(ed,eu)while em~=W do ec[em],ef=K(ed,eu),ef+1
em=K(ed,eu)end else local ef=V(ed,el)
for ew=1,ef do em=K(ed,eu)ec[em]=K(ed,eu)end end;return ec end;local ea={}
local function eo(ed,el,eu)local ec=V(ed,el)local em=K(ed,eu)
local ef=eu and eu[ec]or ea[ec]if ef then return ef(em)end;return C(ec,em)end
local function ei(ed)local el=P(ed)local eu=P(ed)local ec=el<128 and 1 or-1;eu=eu+
(el*256)%1024;el=I(el,2)%32
if el==0 then return ec*E(eu,-24)elseif el~=31 then return ec*E(eu+
1024,el-25)elseif eu==0 then return ec*k else return z end end
local function en(ed)local el=P(ed)local eu=P(ed)local ec=el<128 and 1 or-1
el=el*2%256+I(eu,7)eu=eu%128;eu=eu*256+P(ed)eu=eu*256+P(ed)if el==0 then return
ec*E(el,-149)elseif el~=0xff then return ec*E(eu+2^23,el-150)elseif eu==0 then
return ec*k else return z end end
local function es(ed)local el=P(ed)local eu=P(ed)local ec=el<128 and 1 or-1
el=el%128*16+I(eu,4)eu=eu%16;eu=eu*256+P(ed)eu=eu*256+P(ed)
eu=eu*256+P(ed)eu=eu*256+P(ed)eu=eu*256+P(ed)eu=eu*256+P(ed)
if
el==0 then return ec*E(el,-149)elseif el~=0xff then
return ec*E(eu+2^52,el-1075)elseif eu==0 then return ec*k else return z end end;if O then function en(ed)return O(">f",Y(ed,4))end;function es(ed)
return O(">d",Y(ed,8))end end
local function eh(ed,el,eu)if el==24 then
el=P(ed)end
if el==20 then return false elseif el==21 then return true elseif el==22 then return M elseif el==23 then return F elseif el==25 then return ei(ed)elseif
el==26 then return en(ed)elseif el==27 then return es(ed)elseif el==31 then return W end;if eu and eu.simple then return eu.simple(el)end;return L(el)end;B[0]=Q;B[1]=J;B[2]=X;B[3]=Z;B[4]=ee;B[5]=et;B[6]=eo;B[7]=eh
local function er(ed,el)local eu={}local ec=1;local em
if
c(el)=="function"then em=el elseif c(el)=="table"then em=el.more elseif el~=nil then
u(("bad argument #2 to 'decode' (function or table expected, got %s)"):format(c(el)))end
if c(em)~="function"then function em()u"input too short"end end
function eu:read(ef)local ew=ed:sub(ec,ec+ef-1)
if#ew<ef then ew=em(ef-#ew,eu,el)if
ew then self:write(ew)end;return self:read(ef)end;ec=ec+ef;return ew end
function eu:write(ef)ed=ed..ef;if ec>256 then ed=ed:sub(ec+1)ec=1 end;return#ef end;return K(eu,el)end
return{encode=H,decode=er,decode_file=K,type_encoders=S,type_decoders=B,tagged_decoders=ea,simple=L,tagged=C,null=M,undefined=F}end;return a["ecnet.ecnet"](...)