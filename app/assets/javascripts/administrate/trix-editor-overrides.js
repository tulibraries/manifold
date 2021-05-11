

window.addEventListener("trix-file-accept", function(event) {
  const acceptedTypes = ['image/jpeg', 'image/png']
  if (!acceptedTypes.includes(event.file.type)) {
    event.preventDefault()
    alert("Only support attachment of jpeg or png files")
  }
})

window.addEventListener("trix-file-accept", function(event) {
  const maxFileSize = 1024 * 1024 // 1MB 
  if (event.file.size > maxFileSize) {
    event.preventDefault()
    alert("Only support attachment files up to size 1MB!")
  }
})

addEventListener("trix-initialize", function (event) {
    new RichText(event.target)
})

addEventListener("trix-action-invoke", function (event) {
  if (event.actionName == "x-horizontal-rule") insertHorizontalRule()

  function insertHorizontalRule() {
    event.target.editor.insertAttachment(buildHorizontalRule())
  }

  function buildHorizontalRule() {
    return new Trix.Attachment({ content: "<hr>", contentType: "vnd.rubyonrails.horizontal-rule.html" })
  }
})

class RichText {
  constructor(element) {
    this.element = element

    this.insertHeadingElements()
    this.insertDividerElements()
  }

  insertHeadingElements() {
    this.removeOriginalHeadingButton()
    this.insertNewHeadingButton()
    this.insertHeadingDialog()
  }

  removeOriginalHeadingButton() {
    this.buttonGroupBlockTools.removeChild(this.originalHeadingButton)
  }

  insertNewHeadingButton() {
    this.buttonGroupBlockTools.insertAdjacentHTML("afterbegin", this.headingButtonTemplate)
  }

  insertHeadingDialog() {
    this.dialogsElement.insertAdjacentHTML("beforeend", this.dialogHeadingTemplate)
  }

  insertDividerElements() {
    this.quoteButton.insertAdjacentHTML("afterend", this.horizontalButtonTemplate)
  }

  get buttonGroupBlockTools() {
    return this.toolbarElement.querySelector("[data-trix-button-group=block-tools]")
  }

  get buttonGroupTextTools() {
    return this.toolbarElement.querySelector("[data-trix-button-group=text-tools]")
  }

  get dialogsElement() {
    return this.toolbarElement.querySelector("[data-trix-dialogs]")
  }

  get originalHeadingButton() {
    return this.toolbarElement.querySelector("[data-trix-attribute=heading1]")
  }

  get quoteButton() {
    return this.toolbarElement.querySelector("[data-trix-attribute=quote]")
  }

  get toolbarElement() {
    return this.element.toolbarElement
  }

  get horizontalButtonTemplate() {
    return '<button type="button" class="trix-button trix-button--icon trix-button--icon-horizontal-rule" data-trix-action="x-horizontal-rule" tabindex="-1" title="Divider">Divider</button>'
  }

  get headingButtonTemplate() {
    return '<button type="button" class="trix-button trix-button--icon trix-button--icon-heading-1" data-trix-action="x-heading" title="Heading" tabindex="-1">Heading</button>'
  }

  get dialogHeadingTemplate() {
    return `
      <div class="trix-dialog trix-dialog--heading" data-trix-dialog="x-heading" data-trix-dialog-attribute="x-heading">
        <div class="trix-dialog__link-fields">
          <input type="text" name="x-heading" class="trix-dialog-hidden__input" data-trix-input>
          <div class="trix-button-group">
            <button type="button" class="trix-button trix-button--dialog" data-trix-attribute="heading1">H1</button>
            <button type="button" class="trix-button trix-button--dialog" data-trix-attribute="heading2">H2</button>
            <button type="button" class="trix-button trix-button--dialog" data-trix-attribute="heading3">H3</button>
            <button type="button" class="trix-button trix-button--dialog" data-trix-attribute="heading4">H4</button>
            <button type="button" class="trix-button trix-button--dialog" data-trix-attribute="heading5">H5</button>
            <button type="button" class="trix-button trix-button--dialog" data-trix-attribute="heading6">H6</button>
          </div>
        </div>
      </div>
    `
  }
}
