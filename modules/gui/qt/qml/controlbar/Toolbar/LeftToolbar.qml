import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

import "qrc:///controlbar/Menu/"

ToolBar{
    height: parent.height
    RowLayout{
        height: parent.height
        Repeater {
            model: leftList
            delegate: ToolButton {
                Image {
                    source: controlbar.getIconFromName(widgetName)
                }

                SubtitleMenu {
                    id: subtitleMenu
                    y: 110
                }
                onClicked: {
                    console.log(model.modelData.widgetName + " clicked.")
                    if (model.modelData.widgetName === "Subtitle" ) {
                        // console.log("subtile options:")
                        subtitleMenu.open()
                    }
                }
            }
        }
        ListModel {
            id: leftList
            ListElement {widgetName: "Bookmark"}
            ListElement {widgetName: "Subtitle"}
            ListElement {widgetName: "Random"}
            ListElement {widgetName: "Loop"}
        }
    }
}
