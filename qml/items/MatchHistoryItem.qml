import QtQuick 2.0
import QtGraphicalEffects 1.12

Item {
    width: 250
    height: 70
    Rectangle {
        id: match_history_rect
        color: "#2f3136"
        radius: 10
        anchors.fill:parent

        Row {
            id: row
            anchors.fill: parent
            spacing: 5

            Item {
                id: champion_image_item
                width: parent.height
                height: parent.height

                Image {
                    id: champion_image_raw
                    source: '../../components/images/' + match_champion_image
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: false
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 10
                    height: parent.height - 10


                }

                Rectangle {
                    id: mask
                    visible: false
                    width: parent.width
                    height: parent.height
                    radius: 15
                }

                OpacityMask {
                    id: champion_image
                    anchors.fill: champion_image_raw
                    source: champion_image_raw
                    maskSource: mask

                    CustomToolTip {
                        text: match_champion
                        visible: champion_image_area.containsMouse
                    }

                    MouseArea {
                        id: champion_image_area
                        anchors.fill: parent
                        hoverEnabled: true
                        z: 1
                    }
                }
            }

            Column {
                height: parent.height
                width: parent.width / 4

                Text {
//                    color: "#7d7d7d"
                    color:
                        if(match_result == 'Victory') {
                            return "#62A340"
                        }
                        else if (match_result == 'Defeat') {
                            return '#BD3E47'
                        }
                        else if (match_result == 'Remake') {
                            return '#7d7d7d'
                        }
                    text: match_result
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 14
                    font.bold: true
                    font.capitalization: Font.AllUppercase
                    font.family: font_family
                }

                Text {
                    text: match_type
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 12
                    font.family: font_family
                    color: '#ffffff'
                }

                Row {
                    Image {
                        id: item_1
                        width: 20
                        height: 20
                        anchors.margins: 2
                        source: '../../components/images/' + match_spell1Image
                    }
                    Image {
                        id: item_2
                        width: 20
                        height: 20
                        anchors.margins: 2
                        source: '../../components/images/' + match_spell2Image
                    }
                }
            } // Column
            Item {
                id: item1
                width: columnID.width
                height: parent.height
                Column {
                    id: columnID
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 5

                    Row {
                        id: items_row


                        property var item_image_height: 30
                        property var item_image_width: 30

                        spacing: 2

                        Image {
                            id: row_item_0
                            width: items_row.item_image_width
                            height: items_row.item_image_height

    //                        sourceSize.width: item_image_width
    //                        sourceSize.height: item_image_height

                            anchors.margins: 2
                            source: '../../components/images/' + item_0_image
                        }
                        Image {
                            id: row_item_1
                            width: items_row.item_image_width
                            height: items_row.item_image_height

    //                        sourceSize.width: item_image_width
    //                        sourceSize.height: item_image_height
                            anchors.margins: 2
                            source: '../../components/images/' + item_1_image
                        }
                        Image {
                            id: row_item_2
                            width: items_row.item_image_width
                            height: items_row.item_image_height

    //                        sourceSize.width: item_image_width
    //                        sourceSize.height: item_image_height
                            anchors.margins: 2
                            source: '../../components/images/' + item_2_image
                        }
                        Image {
                            id: row_item_4
                            width: items_row.item_image_width
                            height: items_row.item_image_height

    //                        sourceSize.width: item_image_width
    //                        sourceSize.height: item_image_height
                            anchors.margins: 2
                            source: '../../components/images/' + item_4_image
                        }
                        Image {
                            id: row_item_5
                            width: items_row.item_image_width
                            height: items_row.item_image_height

    //                        sourceSize.width: item_image_width
    //                        sourceSize.height: item_image_height
                            anchors.margins: 2
                            source: '../../components/images/' + item_5_image
                        }
                        Image {
                            id: row_item_6
                            width: items_row.item_image_width
                            height: items_row.item_image_height

    //                        sourceSize.width: item_image_width
    //                        sourceSize.height: item_image_height
                            anchors.margins: 2
                            source: '../../components/images/' + item_6_image
                        }

                        Image {
                            id: row_item_3
                            width: items_row.item_image_width
                            height: items_row.item_image_height

    //                        sourceSize.width: item_image_width
    //                        sourceSize.height: item_image_height
                            anchors.margins: 2
                            source: '../../components/images/' + item_3_image
                        }
                    } //Row

                    Item {
                        id: item2
                        width: columnID.width
                        height: kda_row_id.height

                        Row {
                            id: kda_row_id
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 10

                            Text {
                                text: match_kills + '/' + match_deaths + '/' + match_assists
                                verticalAlignment: Text.AlignVCenter

                                font.pointSize: 10
                                font.family: font_family
                                color: '#ffffff'
                            }

                            Text {
                                text: match_ratio + ' KDA'
                                verticalAlignment: Text.AlignVCenter

                                font.pointSize: 10
                                font.family: font_family
                                color: '#ffffff'
                            }

                            Text {
                                text: match_cs + ' (' + match_csps + ') CS'
                                verticalAlignment: Text.AlignVCenter

                                font.pointSize: 10
                                font.family: font_family
                                color: '#ffffff'
                            }
                        } //Row
                    }
                }
            } //Item

            Item {
                width: 100
                height: parent.height

                Column {
                    Text {
                        text: match_last_time
                        verticalAlignment: Text.AlignVCenter

                        font.pointSize: 10
                        font.family: font_family
                        color: '#ffffff'

                    }

                    Item {
                        width: match_lenght_id.width
                        height: match_lenght_id.height


                        Text {
                            id: match_lenght_id
                            text: match_length
                            verticalAlignment: Text.AlignVCenter

                            font.pointSize: 10
                            font.family: font_family
                            color: '#ffffff'

                            CustomToolTip {
                                text: match_time
                                visible: match_lenght_area.containsMouse
                            }

                            MouseArea {
                                id: match_lenght_area
                                anchors.fill: parent
                                hoverEnabled: true
                                z: 1
                            }
                        }
                    }
                }
            }
        }

//            Item {
//                id: item1
//                height: parent.height
//                width: match_history_rect.width / 4

//                Row {
//                    id: row
//                    anchors.fill: parent
//                    anchors.margins: 2

//                    Column {
//                        anchors.left: champion_name.right
//                        anchors.top: parent.top
//                        anchors.bottom: parent.bottom
//                        anchors.bottomMargin: 2
//                        anchors.topMargin: 2
//                        anchors.leftMargin: 1

//                        Image {
//                            id: item_1
//                            width: 20
//                            height: 20
//                            anchors.margins: 2
//                            source: '../../components/images/' + match_spell1Image
//                        }
//                        Image {
//                            id: item_2
//                            width: 20
//                            height: 20
//                            anchors.margins: 2
//                            source: '../../components/images/' + match_spell2Image
//                        }
//                    }
//                }
//            }

//            Item {
//                height: parent.height
//                clip: true
//                width: match_history_rect.width / 4

//                Column {
//                    id: columId
//                    anchors.fill: parent
//                    anchors.margins: 2
//                    Text {
//                        text: match_type
//                        verticalAlignment: Text.AlignVCenter
//                        font.pointSize: 12
//                        font.family: font_family
//                        color: '#ffffff'
//                    }

//                    Text {
//                        text: match_last_time
//                        verticalAlignment: Text.AlignVCenter
//                        font.pointSize:10
//                        font.family: font_family
//                    }

//                    Text {
//                        text: match_result
//                        verticalAlignment: Text.AlignVCenter
//                        font.pointSize: 8
//                        font.family: font_family
//                    }
//                    Text {
//                        text: match_length
//                        verticalAlignment: Text.AlignVCenter
//                        font.pointSize: 8
//                        font.family: font_family
//                    }

//                }
//            }

//            Item {
//                id: item3
//                height: parent.height
//                width: match_history_rect.width / 4

//                Column {
//                    id: colum2Id
//                    anchors.fill: parent
//                    anchors.margins: 2

//                    Text {
//                        text: match_kills + ' / ' + match_deaths + ' / ' + match_assists
//                        verticalAlignment: Text.AlignVCenter

//                        font.pointSize:10
//                        font.family: font_family
//                    }

//                    Text {
//                        text: match_ratio + ' KDA'
//                        verticalAlignment: Text.AlignVCenter

//                        font.pointSize:10
//                        font.family: font_family
//                    }

//                    Text {
//                        text: match_time
//                        verticalAlignment: Text.AlignVCenter

//                        font.pointSize:10
//                        font.family: font_family
//                    }
//                }
//            }
//        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.5}
}
##^##*/
