/*****************************************************************************
 * MusicAlbumsDisplay.qml : Component to display when category is "albums"
 ****************************************************************************
 * Copyright (C) 2006-2011 VideoLAN and AUTHORS
 * $Id$
 *
 * Authors: Maël Kervella <dev@maelkervella.eu>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

import QtQuick 2.0
import QtQuick.Controls 2.0

import "qrc:///utils/" as Utils
import "qrc:///style/"

Loader {
    id: viewLoader

    // notify when the view has changed
    function changedView() {
        viewLoader.sourceComponent = medialib.isGridView() ? gridViewComponent_id : listViewComponent_id;
        console.log("View changed");
    }
    // Force the data to be reloaded
    function reloadData() {
        viewLoader.item.model = medialib.getObjects();
        console.log( "Data reloaded" );
    }

    sourceComponent: medialib.isGridView() ? gridViewComponent_id : listViewComponent_id

    /* Grid View */
    Component {
        id: gridViewComponent_id

        Utils.ExpandGridView {
            id: gridView_id

            model: medialib.getObjects()

            cellWidth: VLCStyle.cover_normal
            cellHeight: VLCStyle.cover_normal + VLCStyle.fontSize_small + VLCStyle.margin_xsmall
            expandHeight: VLCStyle.heightBar_xxlarge

            rowSpacing: VLCStyle.margin_xxxsmall
            colSpacing: VLCStyle.margin_xxxsmall
            expandSpacing: VLCStyle.margin_xxxsmall
            expandCompact: true

            expandDuration: VLCStyle.timingGridExpandOpen

            delegate : Utils.GridItem {
                width: gridView_id.cellWidth
                height: gridView_id.cellHeight

                cover : Image { source: model.album_cover || VLCStyle.noArtCover }
                name : model.album_title || "Unknown title"
                date : model.album_release_year !== "0" ? model.album_release_year : ""
                infos : model.album_duration + " - " + model.album_nb_tracks + " tracks"

                onItemClicked : console.log('Clicked on details : '+model.album_title)
                onPlayClicked: {
                    console.log('Clicked on play : '+model.album_title);
                    medialib.addAndPlay(currentIndex)
                }
                onAddToPlaylistClicked : {
                    console.log('Clicked on addToPlaylist : '+model.album_title);
                    medialib.addToPlaylist(currentIndex);
                }
            }
            expandDelegate: MusicAlbumsGridExpandDelegate {
                width: parent.parent.width
                height: gridView_id.expandHeight
            }

            ScrollBar.vertical: ScrollBar { }
        }
    }

    /* List View */
    Component {
        id: listViewComponent_id

        ListView {
            spacing: VLCStyle.margin_xxxsmall

            model: medialib.getObjects()
            delegate : Utils.ListExpandItem {
                height: VLCStyle.icon_normal
                width: parent.width

                cover: Image {
                    id: cover_obj

                    width: VLCStyle.icon_normal
                    height: VLCStyle.icon_normal

                    source: model.album_cover || VLCStyle.noArtCover

                    states: State {
                        name: "expanded"
                        PropertyChanges {target: cover_obj; width: VLCStyle.icon_xlarge; height: VLCStyle.icon_xlarge}
                    }
                    Behavior on height { PropertyAnimation { duration: VLCStyle.timingListExpandOpen } }
                    Behavior on width { PropertyAnimation { duration: VLCStyle.timingListExpandOpen } }
                }
                line1: Text{
                    text: (model.album_title || "Unknown title")+" ["+model.album_duration+"]"
                    font.bold: true
                    elide: Text.ElideRight
                    color: VLCStyle.textColor
                    font.pixelSize: VLCStyle.fontSize_normal
                }
                line2: Text{
                    text: model.album_main_artist || "Unknown artist"
                    elide: Text.ElideRight
                    color: VLCStyle.textColor
                    font.pixelSize: VLCStyle.fontSize_xsmall
                }
                expand: Utils.TracksDisplay {
                    height: album_nb_tracks * (VLCStyle.fontSize_normal + VLCStyle.margin_xxxsmall) - VLCStyle.margin_xxxsmall
                    width: parent.width

                    tracks: album_tracks
                    parentIndex: index
                }

                onPlayClicked: {
                    console.log('Clicked on play : '+model.album_title);
                    medialib.addAndPlay(index)
                }
                onAddToPlaylistClicked: {
                    console.log('Clicked on addToPlaylist : '+model.album_title);
                    medialib.addToPlaylist(index);
                }
            }

            ScrollBar.vertical: ScrollBar { }
        }
    }
}