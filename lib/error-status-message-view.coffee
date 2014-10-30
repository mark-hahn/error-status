class ErrorStatusMessageView extends HTMLElement
	initialize: (@error) ->
		@classList.add 'tool-panel', 'panel-bottom', 'padded'
		@textContent = @error.toString()

		@expandButton = document.createElement 'span'
		@expandButton.classList.add 'error-expand'
		@expandButton.addEventListener 'click', =>
			if @classList.contains 'expanded'
				@classList.remove 'expanded'
				@expandButton.textContent = '(more...)'
			else
				@classList.add 'expanded'
				@expandButton.textContent = '(less...)'

		@expandButton.textContent = '(more...)'

		@removeButton = @createIconButton 'x'
		@removeButton.addEventListener 'click', =>
			@destroy()

		@clipboardButton = @createIconButton 'clippy'
		@clipboardButton.addEventListener 'click', =>
			atom.clipboard.write @error.stack ? @error.toString()

		@expanded = document.createElement 'div'
		@expanded.classList.add 'inset-panel', 'padded'
		@expanded.textContent = error.stack ? 'No stacktrace available.'

		btnGroup = document.createElement 'div'
		btnGroup.classList.add 'btn-group', 'pull-right'

		@appendChild @expandButton

		if atom.packages.isPackageLoaded('bug-report')
			@reportButton = @createIconButton 'issue-opened'
			@reportButton.appendChild document.createTextNode ' Report'
			@reportButton.addEventListener 'click', (e) =>
				atom.workspaceView.trigger 'bug-report:open', error: @error
				if atom.config.get 'error-status.closeOnReport'
					@destroy()

			btnGroup.appendChild @reportButton

		btnGroup.appendChild @clipboardButton
		btnGroup.appendChild @removeButton

		@appendChild btnGroup

		@appendChild @expanded

	createIconButton: (iconName) ->
		icon = document.createElement 'span'
		icon.classList.add 'icon', 'icon-' + iconName
		button = document.createElement 'button'
		button.classList.add 'btn', 'btn-sm'
		button.appendChild icon

		button

	attach: ->
		atom.workspaceView.prependToBottom this

	destroy: ->
		@remove()

module.exports = document.registerElement 'error-status-message', prototype: ErrorStatusMessageView.prototype
