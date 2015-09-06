Widget = require "./widget.cjsx"
PAGE_MODES = (require "../../constants.cjsx").PAGE_MODES
PageStateStore = require "../../stores/PageStateStore.cjsx"

TimeWidget = Widget.createWidgetClass
    displayName: "MailWidget"

    mixins: [
        Widget.WidgetMixin,
        Reflux.connect(PageStateStore, "pageState")
    ]

    getDefaultProps: () ->
        {
            messages: [
                {
                    title: "Rutgers Delivery Ready for collection"
                    author: "noreplypluginrutgers@bybox.com"
                    body: "A package and/or mail has arrived from the
                           Rutgets Mail Services Locker System at..."
                },
                {
                    title: "Confirmation instructions"
                    author: "team@hackru.org"
                    body: "Thank you for signing up! By confirming your
                           account, you are registering for HackRU Fall 2015.
                           Due to high demand and limited space..."
                },
                {
                    title: "PennApps Hacker Resources"
                    author: "contact@pennapps.com"
                    body: "Hi PennApps Hackers! We’re just a few days away
                           from PennApps now, and since we’ve got the
                           logistics out of the way, we’re now moving..."
                }
            ]
        }

    acceptsDim: (x, y) ->
        return x == 2 && y == 2

    render: ->
        editing = this.state.pageState == PAGE_MODES.EDIT
        classes = Object.assign(this.widgetClasses(),{
            "core-mail-widget": true
        })

        invertedColors = {
            backgroundColor: this.state.userStyle.widgetForeground
            color: this.state.userStyle.widgetBackground
        }

        mkMessage = (message, index) ->
            <a key={index} href="#">
                <div className="message">
                    <span className="message-title">{message.title}</span>
                    <span className="message-author">{message.author}</span>
                    <span className="message-message">{message.body}</span>
                </div>
            </a>

        messages = (mkMessage m, i for m, i in this.props.messages)

        <div className={classNames(classes)}
             onMouseDown={ if editing then this.wStartDrag else undefined}
             onMouseUp={ if editing then this.wEndDrag else undefined}
             style={this.widgetStyle()}>

             <div className="window-bar"
                  style={invertedColors}>
                <img src="img/icons/email.svg" />
                <a href="#">
                    <span className="icon options">
                        <img src="img/icons/options-icon.svg" />
                    </span>
                </a>
                <h3>goodjobpj@gmail.com</h3>
                <a href="#">
                    <h4>10 unread</h4>
                </a>
            </div>

            <div className="inbox">
                {messages}
            </div>
            <a href="#">
                <div className="read-more">
                    <span className="read-more-icon">
                        <img src="img/icons/down-chevron.svg" />
                    </span>
                </div>
            </a>

        </div>

module.exports = TimeWidget