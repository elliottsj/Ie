Reflux = require("reflux")
React  = require("react/addons")

CONSTANTS  = require("../constants.cjsx")
PAGE_MODES = CONSTANTS.PAGE_MODES
BKG_MODES  = CONSTANTS.BKG_MODES

UserInfoOptionStore = require("../stores/UserInfoOptionStore.cjsx")
StyleOptionStore    = require("../stores/StyleOptionStore.cjsx")
GridOptionStore     = require("../stores/GridOptionStore.cjsx")

PageStateStore = require("../stores/PageStateStore.cjsx")

Actions       = require("../actions.cjsx")
UIActions     = Actions.UIActions
OptionActions = Actions.OptionActions

legibleVariableName = (str) ->
    out = str[0].toUpperCase()
    for char in str.substring(1)
        if char == char.toUpperCase()
            out += " " + char
        else
            out += char
    return out

Options = React.createClass
    displayName: "Options"

    mixins: [
        Reflux.connect(StyleOptionStore, "styleOptions"),
        Reflux.connect(GridOptionStore, "gridOptions"),
        Reflux.connect(UserInfoOptionStore, "userInfoOptions")]

    _handleEditOption: (store, name, event) ->
        if store.validateOption(name, event.target.value)
            console.log "passed validation (#{name}, #{event.target.value})"
            store.onEditOption(
                name,
                event.target.value)
        else
            console.log "failed validation (#{name}, #{event.target.value})"

    _editOption: (store, name) ->
        self = this
        (event) -> self._handleEditOption(store, name, event)

    _handleBackgroundToggle: (event) ->
        mode = BKG_MODES.BKG_COLOR
        if event.target.checked == true
            mode = BKG_MODES.BKG_IMG
        OptionActions.editOption("backgroundMode", mode)

    _isImageMode: ->
        if (this.state.styleOptions.backgroundMode == BKG_MODES.BKG_IMG)
            return true
        else
            return false

    _handleBackgroundImage: ->
        fileList = document.getElementById("background-image").files
        file = fileList[0]
        reader = new FileReader()
        reader.onload = (e) ->
            console.log(reader.result)
            OptionActions.editOption(
                "backgroundImage",
                "url(#{reader.result})")
        reader.readAsDataURL(file)

    _exitOptionsMode: ->
        document.getElementById("options").className = ""
        UIActions.enterMode(PAGE_MODES.LIVE)

    render: () ->
        self = this
        inputFromField = (store, fieldName, fieldValue) ->
            inputType = switch typeof fieldValue
                when "string" then "text"
                when "boolean" then "checkbox"
                else "text"

            callback = self._editOption(store, fieldName)

            return <label
                htmlFor={fieldName}
                key={fieldName}>
                {legibleVariableName(fieldName)}
                <input type={inputType}
                    id={fieldName}
                    defaultValue={fieldValue}
                    onChange={callback} />
            </label>

        makeOptions = (store, obj) ->
            (inputFromField(store, key, obj[key]) for key in Object.keys(obj))

        userStyleInputs = makeOptions(
            StyleOptionStore,
            this.state.styleOptions)

        userInfoInputs = makeOptions(
            UserInfoOptionStore,
            this.state.userInfoOptions)


        # gridStyleInputs = this._makeOptions(
        #     GridOptionStore,
        #     this.state.gridOptions)

        <div id="options">
            <h1>Style</h1>
            {userStyleInputs}

            <h1>User Info</h1>
            {userInfoInputs}

            <h1>Install Widgets</h1>
            todo: put anything here

            <button onClick = { this._exitOptionsMode }>
                Close Menu
            </button>


        </div>

    # getInitialState:
    #   GlobalOptionsStore.getInitialState.bind(GlobalOptionsStore)


module.exports = Options


           # <label htmlFor="widget-background">Widget Background Color</label>
            # <input type="text"
            #     id="widget-background"
            #     defaultValue={ this.state.styleOptions.widgetBackground }
            #     onChange={ this._editGlobalOption("widgetBackground") } />
            # <label htmlFor="widget-foreground">Widget Foreground Color</label>
            # <input type="text"
            #     id="widget-foreground"
            #     defaultValue={ this.state.styleOptions.widgetForeground }
            #     onChange={ this._editGlobalOption("widgetForeground") } />
            # <label htmlFor="widgetBorder">Widget Border Color</label>
            # <input type="text"
            #     id="widget-border"
            #     defaultValue={ this.state.styleOptions.widgetBorder }
            #     onChange={ this._editGlobalOption("widgetBorder") } />
            # <input type="checkbox"
            #     id="background-mode"
            #     checked={ this._isImageMode() }
            #     onChange={ this._handleBackgroundToggle } />
            # <label htmlFor="background-mode">Use Background Image</label>
            # <label htmlFor="background-image">Background Image File</label>
            # <input type="file"
            #     id="background-image"
            #     disabled={ not this._isImageMode() }
            #     onChange={ this._handleBackgroundImage } />
            # <label htmlFor="background">Background</label>
            # <input type="text"
            #     id="background"
            #     defaulValue={ this.state.styleOptions.backgroundColor }
            #     onChange={ this._editGlobalOption("backgroundColor") }  />
            # <label htmlFor="foreground">Foreground</label>
            # <input type="text"
            #     id="foreground"
            #     defaulValue={ this.state.styleOptions.foreground }
            #     onChange={ this._editGlobalOption("foreground") } />
