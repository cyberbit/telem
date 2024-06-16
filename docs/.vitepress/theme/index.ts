// https://vitepress.dev/guide/custom-theme
import { h } from 'vue'
import type { Theme } from 'vitepress'
import DefaultTheme from 'vitepress/theme'
import TelemLayout from './TelemLayout.vue'
import './style.css'

import PropertiesTable from '../../components/PropertiesTable.vue'
import MetricTable from '../../components/MetricTable.vue'
import RepoLink from '../../components/RepoLink.vue'
import Demo from '../../components/Demo.vue'

export default {
  extends: DefaultTheme,
  Layout: TelemLayout,
  enhanceApp({ app, router, siteData }) {
    app.component('PropertiesTable', PropertiesTable)
    app.component('MetricTable', MetricTable)
    app.component('RepoLink', RepoLink)
    app.component('Demo', Demo)
  }
} satisfies Theme
