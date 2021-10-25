const openForm = function () {
  const form = document.querySelector("#tta-activity-form")
  form.classList.remove("display-none")
  document.querySelector("#tta-report-display-id").focus()
}

const closeForm = function (containerId = "#tta-activity-form") {
  const formContainer = document.querySelector(containerId)
  formContainer.classList.add("display-none")
  const groupContainer = formContainer.querySelector(".usa-form-group")
  groupContainer.classList.remove("usa-form-group--error")
  const errorMessage = groupContainer.querySelector("span.usa-error-message")
  errorMessage.innerText = ""
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
  const input = document.querySelector("#tta-report-display-id")
  input.value = ""
})

document.querySelectorAll(".js-edit-tta").forEach((el) => {
  el.addEventListener('click', event => {
    event.preventDefault()

    // hide details
    const id = event.currentTarget.dataset.id
    document.querySelector(`#tta-activity-show-${id}`).classList.add("display-none")
    // show form
    const form = document.querySelector(`#edit-tta-activity-${id}`)
    form.classList.remove("display-none")
    form.querySelector("input[type='text']").focus()
  })
})

document.querySelectorAll(".js-close-edit-tta").forEach((el) => {
  el.addEventListener('click', event => {
    event.preventDefault()

    const id = event.currentTarget.dataset.id
    // hide form
    closeForm(`#edit-tta-activity-${id}`)
    // show detail
    document.querySelector(`#tta-activity-show-${id}`).classList.remove("display-none")
  })
})

document.querySelectorAll(".js-open-unlink-modal").forEach((el) => {
  el.addEventListener('click', event => {
    const displayId = event.currentTarget.dataset.displayId
    // add display id to hidden input form
    const hiddenInput = document.querySelector("#hidden-tta-display_id")
    hiddenInput.value = displayId
  })
})

document.querySelectorAll(".ct-close-modal").forEach((el) => {
  el.addEventListener('click', event => {
    // remove display id from hidden input form
    const hiddenInput = document.querySelector("#hidden-tta-display_id")
    hiddenInput.value = ""
  })
})
