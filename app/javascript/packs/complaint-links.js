const openForm = function (formId, itemId) {
  const form = document.querySelector(formId)
  form.classList.remove("display-none")
  document.querySelector(itemId).focus()
}

const clearFormValue = function (elementId) {
  const input = document.querySelector(elementId)
  input.value = ""
}

const closeForm = function (containerId) {
  const formContainer = document.querySelector(containerId)
  formContainer.classList.add("display-none")

  const groupContainer = formContainer.querySelector(".usa-form-group")
  groupContainer.classList.remove("usa-form-group--error")
  const errorMessage = groupContainer.querySelector("span.usa-error-message")
  errorMessage.innerText = ""
}

// TTA open form

document.querySelector("#js-add-tta-report").addEventListener('click', event => {
  event.preventDefault()
  openForm("#tta-activity-form", "#tta-report-display-id")
})

document.querySelector("#tta-report-icon").addEventListener('click', event => {
  openForm("#tta-activity-form", "#tta-report-display-id")
})

// ITAMS open form

document.querySelector("#js-add-monitoring-review").addEventListener('click', event => {
  event.preventDefault()
  openForm("#monitoring-activity-form", "#monitoring-review-id")
})

document.querySelector("#monitoring-review-icon").addEventListener('click', event => {
  openForm("#monitoring-activity-form", "#monitoring-review-id")
})

// Close form

document.querySelector("#js-close-tta-form").addEventListener('click', event => {
  event.preventDefault()
  closeForm("#tta-activity-form")
  clearFormValue("#tta-report-display-id")
})

document.querySelector("#js-close-monitoring-form").addEventListener('click', event => {
  event.preventDefault()
  closeForm("#monitoring-activity-form")
  clearFormValue("#monitoring-review-id")
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

// Unlink form for TTA and Monitoring

document.querySelectorAll(".js-open-unlink-modal").forEach((el) => {
  el.addEventListener('click', event => {
    // note: id here refers to monitoring's review id or a TTA issue's display_id
    const id = event.currentTarget.dataset.id
    const field = event.currentTarget.dataset.inputField
    const hiddenInput = document.querySelector("#hidden-"+field)
    // add id to hidden input form
    hiddenInput.value = id
  })
})

document.querySelectorAll(".ct-close-modal").forEach((el) => {
  el.addEventListener('click', event => {
    // remove id from hidden input forms
    clearFormValue("#hidden-tta-display_id")
    clearFormValue("#hidden-monitoring_review_id")
  })
})
