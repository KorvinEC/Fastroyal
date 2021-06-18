import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.11
import "items"
//import QSystemTrayIcon 1.0


Window  {
    id: mainWindow
    width: 1280
    height: 720
    minimumWidth: 320
    minimumHeight: 520
    visible: true
    color: "#00000000"
    title: qsTr("Fast Royal")

    flags: Qt.Window | Qt.FramelessWindowHint

    property int windowStatus: 0
    property int windowMargin: 5
    property int layoutMargin: 5
    property int layoutPreferedWidth: 75
    property int loader_row_height: 50

//    property int public_height
//    property int public_width


    QtObject {
        id: internal

        function maximizeRestore() {
            if(windowStatus == 0){
                mainWindow.showMaximized()
                windowStatus = 1
                windowMargin = 0
                fullscreen_btn.btnIcon = '../components/icons/fullscreen-exit.svg'
                fullscreen_btn.btnIconHover = '../components/icons/fullscreen-exit.svg'
                fullscreen_btn.btnIconDown = '../components/icons/fullscreen-exit.svg'

            }else{
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 5
                fullscreen_btn.btnIcon = '../components/icons/fullscreen.svg'
                fullscreen_btn.btnIconHover = '../components/icons/fullscreen.svg'
                fullscreen_btn.btnIconDown = '../components/icons/fullscreen.svg'
            }
        }

        function ifMaximizedRestore(){
            if(windowStatus == 1){
                //                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 5
                fullscreen_btn.btnIcon = "../components/icons/fullscreen.svg"
            }
        }
        function restoreMarginx(){
            windowStatus = 0
            windowMargin = 5
            fullscreen_btn.btnIcon = "../components/icons/fullscreen.svg"
        }
    }

    Rectangle {
        id: mainArea
        color: "#202224"
        anchors.fill: parent
        anchors.margins: windowMargin
//        width: public_width
//        height: public_height
        z: 1

//        Component.onCompleted: {
//            public_height = mainWindow.height - 10
//            public_width = mainWindow.width - 10
//        }

        Rectangle {
            id: leftSide
            y: 0
            width: 50
            color: "#202224"
            border.color: "#00000000"
            anchors.left: parent.left
            anchors.top: topSide.bottom
            anchors.bottom: parent.bottom
            anchors.topMargin: 6
            anchors.leftMargin: 0
            anchors.bottomMargin: 0

            ColumnLayout  {
                id: column
                anchors.fill: parent

                CustomLeftButton {
                    id: openDashboardPage
                    Layout.preferredWidth: leftSide.width
                    Layout.preferredHeight: layoutPreferedWidth
                    Layout.bottomMargin: layoutMargin
                    newOrderCount: dashboardPageLoader.item.order_list_count

                    onClicked: {                       
                        openDashboardPage.activeMenu        = true
                        openActiveOrderPage.activeMenu      = false
                        openCompletedOrdersPage.activeMenu  = false
                        openProfilePage.activeMenu          = false
                        openSettingsPage.activeMenu         = false

                        dashboardPageLoader.visible         = true
                        activeOrdersPageLoader.visible      = false
                        completedOrdersPageLoader.visible   = false
                        profilePageLoader.visible           = false
                        settingsPageLoader.visible          = false
                    }
                }

                CustomLeftButton {
                    id: openActiveOrderPage
                    Layout.preferredWidth: leftSide.width
                    Layout.preferredHeight: layoutPreferedWidth
                    Layout.bottomMargin: layoutMargin

                    text: qsTr('Active orders')

                    btnIcon: '../components/icons//journal.svg'

                    newOrderCount: activeOrdersPageLoader.item.order_list_count

                    onClicked: {                      
                        openDashboardPage.activeMenu        = false
                        openActiveOrderPage.activeMenu      = true
                        openCompletedOrdersPage.activeMenu  = false
                        openProfilePage.activeMenu          = false
                        openSettingsPage.activeMenu         = false

                        dashboardPageLoader.visible         = false
                        activeOrdersPageLoader.visible      = true
                        completedOrdersPageLoader.visible   = false
                        profilePageLoader.visible           = false
                        settingsPageLoader.visible          = false

                        backend.load_active_orders()
                    }
                }

                CustomLeftButton {
                    id: openCompletedOrdersPage
                    Layout.preferredWidth: leftSide.width
                    Layout.preferredHeight: layoutPreferedWidth
                    Layout.bottomMargin: layoutMargin

                    text: qsTr('Completed orders')

                    btnIcon: '../components/icons//journal-check.svg'

                    onClicked: { 
                        openDashboardPage.activeMenu        = false
                        openActiveOrderPage.activeMenu      = false
                        openCompletedOrdersPage.activeMenu  = true
                        openProfilePage.activeMenu          = false
                        openSettingsPage.activeMenu         = false

                        dashboardPageLoader.visible         = false
                        activeOrdersPageLoader.visible      = false
                        completedOrdersPageLoader.visible   = true
                        profilePageLoader.visible           = false
                        settingsPageLoader.visible          = false

                        backend.load_completed_orders()
                    }
                }

                CustomLeftButton {
                    id: openProfilePage
                    Layout.preferredWidth: leftSide.width
                    Layout.preferredHeight: layoutPreferedWidth
                    Layout.bottomMargin: layoutMargin

                    text: qsTr('Profile')

                    btnIcon: '../components/icons//person.svg'

                    onClicked: {
                        openDashboardPage.activeMenu        = false
                        openActiveOrderPage.activeMenu      = false
                        openCompletedOrdersPage.activeMenu  = false
                        openProfilePage.activeMenu          = true
                        openSettingsPage.activeMenu         = false

                        dashboardPageLoader.visible         = false
                        activeOrdersPageLoader.visible      = false
                        completedOrdersPageLoader.visible   = false
                        profilePageLoader.visible           = true
                        settingsPageLoader.visible          = false

                        backend.load_profile_info()
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }

                CustomLeftButton {
                    id: openSettingsPage
                    Layout.preferredWidth: leftSide.width
                    Layout.preferredHeight: layoutPreferedWidth
                    Layout.bottomMargin: layoutMargin

                    text: qsTr('Settings')

                    btnIcon: '../components/icons//gear.svg'

                    onClicked: {
                        openDashboardPage.activeMenu        = false
                        openActiveOrderPage.activeMenu      = false
                        openCompletedOrdersPage.activeMenu  = false
                        openProfilePage.activeMenu          = false
                        openSettingsPage.activeMenu         = true

                        dashboardPageLoader.visible         = false
                        activeOrdersPageLoader.visible      = false
                        completedOrdersPageLoader.visible   = false
                        profilePageLoader.visible           = false
                        settingsPageLoader.visible          = true
                    }
                }
            }

            PropertyAnimation {
                id: animationMenu
                target: leftSide
                property: 'width'
                to: if(leftSide.width == 50) return 200; else return 50
                duration: 500
                easing.type: Easing.InOutQuint
            }
        }
        Rectangle {
            id: topSide
            height: 30
            color: "#202224"
            border.color: "#00000000"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0

            Rectangle {
                id: dragableArea
                height: 22
                color: "#00000000"
                border.width: 0
                anchors.left: parent.left
                anchors.right: topButtonsArea.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 0

                MouseArea {
                    height: 30
                    anchors.fill: parent
                    anchors.leftMargin: 0
                    onDoubleClicked: {
                        internal.maximizeRestore()
                    }
                }

                CustomButton {
                    anchors.left: parent.left
                    anchors.top: parent.top

                    btnIcon: "../components/icons//list.svg"
                    btnIconDown: "../components/icons//list.svg"
                    btnIconHover: "../components/icons//list.svg"

                    btnColor: '#202224'
                    btnColorMouseDown: '#00a1f1'
                    btnColorMouseOver: '#23272e'

                    width: 50
                    height: 30

                    icon_width: 20
                    icon_height: 20

                    rect_height: 30
                    rect_width: 50

                    rect_radius: 30

                    onClicked: animationMenu.running = true
                }
            }

            DragHandler {
                onActiveChanged:
                    if(active) {
                         mainWindow.startSystemMove()
                         internal.ifMaximizedRestore()
                     }
            }

            Rectangle {
                id: topButtonsArea
                x: 982
                width: 90
                color: "#00000000"
                border.color: "#00000000"
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0

                Row {
                    id: controlRow
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    CustomButton {
                        width: 30
                        height: 30
                        overlayColor: "#4d4d4d"

                        id: pinBtn

                        property bool pressed_button: false

                        btnIcon: (pressed_button ? "../components/icons/pin-angle-fill.svg" : "../components/icons/pin-angle.svg")
                        btnIconDown: pressed_button ? "../components/icons/pin-angle-fill.svg" : "../components/icons/pin-angle.svg"
                        btnIconHover: pressed_button ? "../components/icons/pin-angle-fill.svg" : "../components/icons/pin-angle.svg"


                        btnColor:  '#202224'
                        btnColorMouseOver: '#2a2c30'
                        btnColorMouseDown: "#40444b"

                        rect_height: 30
                        rect_width: 30

                        icon_height: 20
                        icon_width: 20
                        onClicked: {
                            if(!pressed_button) {
                                mainWindow.flags = Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
                            }
                            else {
                                mainWindow.flags = Qt.Window | Qt.FramelessWindowHint
                            }
                            pinBtn.pressed_button = !pressed_button
                        }

                        CustomToolTip {
                            text: (!pinBtn.pressed_button ? 'Pin to top' : 'Unpin')
//                            text: 'Pin to top'
                            inverted: true
                        }
                    }

                    CustomButton {
                        width: 30
                        height: 30

                        btnIcon: "../components/icons/dash.svg"
                        btnIconDown: "../components/icons/dash.svg"
                        btnIconHover: "../components/icons/dash.svg"

                        btnColor:  '#202224'
                        btnColorMouseOver: '#2a2c30'
                        btnColorMouseDown: "#40444b"

                        rect_height: 30
                        rect_width: 30

                        cursorShapeVal: Qt.ArrowCursor

                        icon_height: 20
                        icon_width: 20
                        onClicked: {
                            mainWindow.showMinimized()
                            internal.restoreMarginx()
                        }
                    }

                    CustomButton {
                        id: fullscreen_btn
                        width: 30
                        height: 30

                        btnIcon: "../components/icons/fullscreen.svg"
                        btnIconDown: "../components/icons/fullscreen.svg"
                        btnIconHover: "../components/icons/fullscreen.svg"

                        btnColor:  '#202224'
                        btnColorMouseOver: '#2a2c30'
                        btnColorMouseDown: "#40444b"

                        rect_height: 30
                        rect_width: 30

                        icon_height: 15
                        icon_width: 15

                        cursorShapeVal: Qt.ArrowCursor

                        onClicked: internal.maximizeRestore()
                    }

                    CustomButton {
                        width: 30
                        height: 30

                        btnIcon: "../components/icons/x.svg"
                        btnIconDown: "../components/icons/x.svg"
                        btnIconHover: "../components/icons/x.svg"

                        btnColor:  '#202224'
                        btnColorMouseOver: '#FF1226'
                        btnColorMouseDown: "#ff7581"

                        rect_height: 30
                        rect_width: 30

                        icon_height: 20
                        icon_width: 20

                        cursorShapeVal: Qt.ArrowCursor

                        onClicked: mainWindow.close()
                    }
                }
            }

        }

        Rectangle {
            id: orderArea
            color: "#40444b"
            radius: 10
            anchors.left: leftSide.right
            anchors.right: parent.right
            anchors.top: topSide.bottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0

            Loader{
                id: dashboardPageLoader
                source: Qt.resolvedUrl('dashboardPage.qml')
                clip: true
                anchors.fill: parent
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                visible: true
                z: 1

                onStatusChanged: {
                    if (dashboardPageLoader.status == Loader.Ready) {
                        backend.load_orders_from_file()
                        openDashboardPage.activeMenu = true
                    }
                }
            }

            Loader{
                id: activeOrdersPageLoader
                anchors.fill: parent
                source: Qt.resolvedUrl('activeOrdersPage.qml')
                clip: true
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                visible: false

                onStatusChanged: {
                    if (activeOrdersPageLoader.status == Loader.Ready) {
                        backend.load_active_orders()
                    }
                }
            }

            Loader{
                id: completedOrdersPageLoader
                anchors.fill: parent
                source: Qt.resolvedUrl('completedOrdersPage.qml')
                clip: true
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                visible: false
                z: 1
                onStatusChanged: {
                    if (completedOrdersPageLoader.status == Loader.Ready) {
                        backend.load_completed_orders()
                    }
                }
            }

            Loader{
                id: profilePageLoader
                anchors.fill: parent
                source: Qt.resolvedUrl('profilePage.qml')
                clip: true
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                visible: false
                z: 1
            }

            Loader{
                id: settingsPageLoader
                anchors.fill: parent
                source: Qt.resolvedUrl('settingsPage.qml')
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                visible: false
            }

            Loader{
                id: notificationPageLoader
                width: 300
                source: Qt.resolvedUrl('notificationPage.qml')
                clip: true
                anchors.rightMargin: 20
                anchors.bottomMargin: 5
                anchors.topMargin: 0
                visible: true
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                z: 2
            }

            Rectangle {
                id: left_bottom
                x: 0
                y: 626
                width: 10
                height: 10
                color: "#40444b"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
            }

            Rectangle {
                id: right_bottom
                x: 960
                y: 626
                width: 10
                height: 10
                visible: true
                color: "#40444b"
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
            }

            Rectangle {
                id: right_top
                x: 960
                y: 0
                width: 10
                height: 10
                visible: true
                color: "#40444b"
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.rightMargin: 0
            }
        }

    }

    Rectangle {
        id: rectangle
        visible: false
        color: "#40444b"
        anchors.fill: parent
        anchors.margins: 5



        Rectangle {
            height: 30

            color: "#202224"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
        }

        DropShadow {
            anchors.fill: mainArea
            horizontalOffset: 0
            verticalOffset: 0
            radius: 10
            samples: 16
            color: "#80000000"
            source: mainArea
            z: 0
        }

    }

    MouseArea {
        id: resizeLeft
        width: 5
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        cursorShape: Qt.SizeHorCursor

        property point clickPos

        onPressed: {
            resizeLeft.clickPos  = Qt.point(mouse.x, mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-resizeLeft.clickPos.x, mouse.y)
            mainWindow.x += delta.x;
            mainWindow.width -= delta.x;
        }
    }


    MouseArea {
        id: resizeTop
        height: 5
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 0
        cursorShape: Qt.SizeVerCursor
        anchors.leftMargin: 0

        property point clickPos

        onPressed: {
            resizeTop.clickPos  = Qt.point(mouse.x, mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-resizeTop.clickPos.x, mouse.y - resizeTop.clickPos.y)
            mainWindow.y += delta.y;
            mainWindow.height -= delta.y;
        }
    }

    MouseArea {
        id: resizeRight
        width: 5
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.topMargin: 0
        cursorShape: Qt.SizeHorCursor
        anchors.bottomMargin: 30

        property point clickPos

        onPressed: {
            resizeRight.clickPos  = Qt.point(mouse.x, mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-resizeRight.clickPos.x, mouse.y - resizeRight.clickPos.y)
            mainWindow.width += delta.x;
        }
    }

    MouseArea {
        id: resizeBot
        height: 5
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 30
        cursorShape: Qt.SizeVerCursor
        anchors.leftMargin: 0
        anchors.bottomMargin: 0

        property point clickPos

        onPressed: {
            resizeBot.clickPos  = Qt.point(mouse.x, mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-resizeBot.clickPos.x, mouse.y - resizeBot.clickPos.y)
            mainWindow.height += delta.y;
        }
    }


    MouseArea {
        id: resizeBotRight
        x: 1161
        y: 648
        width: 30
        height: 30
        visible: true
        z:1
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.rightMargin: 0
        cursorShape: Qt.SizeFDiagCursor

        property point clickPos

        onPressed: {
            resizeBotRight.clickPos  = Qt.point(mouse.x, mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-resizeBotRight.clickPos.x, mouse.y - resizeBotRight.clickPos.y)
            mainWindow.width += delta.x;
            mainWindow.height += delta.y;
        }
    }

    MouseArea {
        id: resizeBotLeft
        y: 648
        width: 20
        height: 20
        anchors.left: parent.left
        z:1
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
//        cursorShape: Qt.SizeFDiagCursor
        cursorShape: Qt.SizeBDiagCursor

        property point clickPos

        onPressed: {
            resizeBotLeft.clickPos  = Qt.point(mouse.x, mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-resizeBotLeft.clickPos.x, mouse.y - resizeBotLeft.clickPos.y)
            mainWindow.width -= delta.x;
            mainWindow.x += delta.x;
            mainWindow.height += delta.y;
        }
    }

    Connections {
        target: backend
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66;height:678;width:1190}
}
##^##*/
