import { table } from 'uswds';

const selector = "th[data-sortable]"

document.querySelector(selector).addEventListener('click', event => {
  event.stopPropagation()

  const { target: eventTarget } = event
  const columnTarget = eventTarget.closest(selector)
  const { nextSort } = columnTarget.dataset

  window.location = nextSort
})
