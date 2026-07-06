import { defineShortcutsSetup } from '@slidev/types'

export default defineShortcutsSetup((nav, base) => {
  return [
    ...base,
    {
      key: 'shift+n',
      fn: () => nav.next(),
      autoRepeat: true,
    },
  ]
})