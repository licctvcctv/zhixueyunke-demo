export function formatDate(str) {
  if (!str) return ''
  return new Date(str).toLocaleString('zh-CN')
}
