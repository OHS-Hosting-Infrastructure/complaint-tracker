const openForm = function () {
  const form = document.querySelector("#tta-activity-form")
  form.classList.remove("display-none")
  document.querySelector("#tta-report-id").focus()
}

const closeForm = function () {
  const input = document.querySelector("#tta-report-id")
  input.value = ""
  const form = document.querySelector("#tta-activity-form")
  form.classList.add("display-none")
}

document.querySelector("#js-add-tta-report").addEventListener('click', event => {
  event.preventDefault()
  openForm()
})

document.querySelector("#tta-report-icon").addEventListener('click', event => {
  openForm()
})

document.querySelector("#js-close-tta-form").addEventListener('click', event => {
  event.preventDefault()
  closeForm()
})
