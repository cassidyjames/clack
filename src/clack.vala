/*
* Copyright (c) 2017 Cassidy James Blaede (http://cassidyjames.com)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 3 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Cassidy James Blaede <c@ssidyjam.es>
*/

int main (string[] args) {
    Gtk.init (ref args);
    const string FALLBACK_TEXT = "Clack is a simple text viewer. To use it, " +
        "open a text file from your file manager or another app.";

    var window = new Gtk.Window ();
    window.title = "Clack";
    window.set_position (Gtk.WindowPosition.CENTER);
    window.set_default_size (800, 600);
    window.destroy.connect (Gtk.main_quit);

    string filename = "README.md";
    string contents;

    try {
        FileUtils.get_contents (filename, out contents);
    } catch (FileError e) {
        stderr.printf ("%s\n", e.message);
        contents = FALLBACK_TEXT;
    }

    Gtk.SourceView view = new Gtk.SourceView ();
    // view.wrap_mode = Gtk.WrapMode.WORD;
    view.editable = false;
    view.buffer.text = contents;


    window.add (view);
    window.show_all ();

    Gtk.main ();
    return 0;
}
