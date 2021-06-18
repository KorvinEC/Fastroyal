import QtQuick.Window 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.3
import 'items'


Window {
    id: login_window
    width: 300
    height: 300
    visible: true
    color: "#00000000"

    Rectangle {
        id: main_rect
        visible: true
        color: "#202224"
        anchors.margins: 5
        radius: 15
        anchors.fill: parent

        DragHandler {
            onActiveChanged:
                if(active) {
                     login_window.startSystemMove()
                 }
        }

        CustomButton {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.rightMargin: 10

            btnIcon: '../components/icons//x.svg'
            btnIconHover: '../components/icons//x.svg'
            btnIconDown: '../components/icons//x.svg'

            btnColor: '#202224'
            btnColorMouseOver: '#2a2c30'
            btnColorMouseDown: 'red'

            width: 35
            height: 35

            rect_radius: 17

            icon_width: 25
            icon_height: 25

            rect_height: 35
            rect_width: 35

            onClicked: {
                login_window.close()
            }
        }

        ColumnLayout {
            id: column
            visible: true
            anchors.fill: parent
            Image {
                id: image

                source: "../components/icons/ekko-feature_2.png"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                fillMode: Image.PreserveAspectFit

                Layout.preferredWidth: 140
                Layout.preferredHeight: 140

                visible: true

                ColorOverlay {
                    anchors.fill: image
                    source: image
                    color: '#ffffff'
                    antialiasing: false
                }
            }

            Item {
                Layout.fillHeight: true
            }

            CustomTextField {
                id: email_text_field
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredWidth: 250
                placeholderText: qsTr("Email")
//                text: 'maksheev777@mail.ru'
                font.family: font_family
            }

            CustomTextField {
                id: password_text_field
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredWidth: 250
                placeholderText: qsTr("Password")
//                text: '12vugabuga34'
                echoMode: TextInput.Password
            }

            RowLayout {
                Layout.maximumWidth: 250
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter


                CustomCheckbox {
                    id: checkBox
                    text: qsTr("Remember me")

                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 40
                }

                Item {
                    Layout.fillWidth: true
                }

                CustomButton {
                    btnIcon: '../components/icons/box-arrow-in-right.svg'
                    btnIconHover: '../components/icons/box-arrow-in-right.svg'
                    btnIconDown: '../components/icons/box-arrow-in-right.svg'

                    btnColor: '#202224'
                    btnColorMouseOver: '#2a2c30'
                    btnColorMouseDown: "#40444b"

                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 40

                    rect_radius: 10

                    icon_width: 25
                    icon_height: 25


                    rect_height: 40
                    rect_width: 40

                    onClicked: {
                        backend.login(checkBox.checked, email_text_field.text, password_text_field.text)
                    }

                    CustomToolTip { text: 'Login';  }
                }
            }

            Item {
                Layout.preferredHeight: 10
            }
        }
    }
    Connections {
        target: backend
    }
}








