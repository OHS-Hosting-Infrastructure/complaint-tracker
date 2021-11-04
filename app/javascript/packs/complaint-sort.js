/**
 * A lot of this code was borrowed from USWDS: https://github.com/uswds/uswds/blob/develop/src/js/components/table.js
 * the default table only sorts in-place and has some issues being adopted to sending the sort requests back to the
 * server
 */

const PREFIX = "usa"
const SORTED = "aria-sort"
const ASCENDING = "ascending"
const DESCENDING = "descending"
const SORT_BUTTON_CLASS = `${PREFIX}-table__header__button`
const SORT_BUTTON = `.${SORT_BUTTON_CLASS}`
const SORTABLE_HEADER = "th[data-remote-sortable]"

const updateSortLabel = (header) => {
  const headerName = header.innerText;
  const sortedDescending = header.getAttribute(SORTED) === DESCENDING;
  const isSorted =
    header.getAttribute(SORTED) === ASCENDING ||
    header.getAttribute(SORTED) === DESCENDING ||
    false;
  const headerLabel = `${headerName}', sortable column, currently ${
    isSorted
      ? `${sortedDescending ? `sorted ${DESCENDING}` : `sorted ${ASCENDING}`}`
      : "unsorted"
  }`;
  const headerButtonLabel = `Click to sort by ${headerName} in ${
    sortedDescending ? ASCENDING : DESCENDING
  } order.`;
  header.setAttribute("aria-label", headerLabel);
  header.querySelector(SORT_BUTTON).setAttribute("title", headerButtonLabel);
};

const createHeaderButton = (header) => {
  const buttonEl = document.createElement("button");
  buttonEl.setAttribute("tabindex", "0");
  buttonEl.classList.add(SORT_BUTTON_CLASS);
  // ICON_SOURCE
  buttonEl.innerHTML = `
  <svg class="${PREFIX}-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
    <g class="descending" fill="transparent">
      <path d="M17 17L15.59 15.59L12.9999 18.17V2H10.9999V18.17L8.41 15.58L7 17L11.9999 22L17 17Z" />
    </g>
    <g class="ascending" fill="transparent">
      <path transform="rotate(180, 12, 12)" d="M17 17L15.59 15.59L12.9999 18.17V2H10.9999V18.17L8.41 15.58L7 17L11.9999 22L17 17Z" />
    </g>
    <g class="unsorted" fill="transparent">
      <polygon points="15.17 15 13 17.17 13 6.83 15.17 9 16.58 7.59 12 3 7.41 7.59 8.83 9 11 6.83 11 17.17 8.83 15 7.42 16.41 12 21 16.59 16.41 15.17 15"/>
    </g>
  </svg>
  `;
  header.appendChild(buttonEl);
  updateSortLabel(header);
};

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(SORTABLE_HEADER).forEach((header) => {
    createHeaderButton(header)
    header.addEventListener('click', event => {
      event.preventDefault()

      const { target: eventTarget } = event
      const columnTarget = eventTarget.closest(SORTABLE_HEADER)
      const { nextSort } = columnTarget.dataset

      window.location = nextSort
    })
  })
})
