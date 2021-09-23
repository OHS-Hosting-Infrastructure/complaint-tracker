const openForm = function () {
  const form = document.querySelector("#tta-activity-form")
  form.classList.remove("display-none")
  document.querySelector("#tta-report-display-id").focus()
}

const closeForm = function () {
  const input = document.querySelector("#tta-report-display-id")
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

document.querySelectorAll(".js-edit-tta").forEach((el) => {
  el.addEventListener('click', event => {
    event.preventDefault()

    // hide details
    const displayId = event.currentTarget.dataset.displayId
    document.querySelector("#tta-activity-show-" + displayId).classList.add("display-none")
    // show form
    const form = document.querySelector("#edit-tta-activity-" + displayId)
    form.classList.remove("display-none")
    form.querySelector("input[type='text']").focus()
  })
})

document.querySelectorAll(".js-close-edit-tta").forEach((el) => {
  el.addEventListener('click', event => {
    event.preventDefault()

    const displayId = event.currentTarget.dataset.displayId
    // hide form
    const form = document.querySelector("#edit-tta-activity-" + displayId)
    form.classList.add("display-none")
    // show detail
    document.querySelector("#tta-activity-show-" + displayId).classList.remove("display-none")
  })
})