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
*/

public class Application : Gtk.Window {

    private Gtk.SourceView view;

    public Application () {
        this.set_position (Gtk.WindowPosition.CENTER);
        this.title = "Clack";
        this.set_default_size (800, 600);
        this.get_style_context ().add_class (Gtk.STYLE_CLASS_VIEW);
        this.destroy.connect (Gtk.main_quit);
        this.realize.connect (choose_file);

        Gtk.ScrolledWindow scroll = new Gtk.ScrolledWindow (null, null);
        this.add (scroll);

        // TODO: Make this translatable?
        const string FALLBACK_TEXT = "Clack is a simple text viewer. To use it, " +
            "open a text file from your file manager or another app.";

        // TODO: Remove .monospace once new elementary stylesheet is released.
        const string STYLES = """
            .monospace {
                font-family: monospace;
            }
        """;

        this.view = new Gtk.SourceView ();
        this.view.wrap_mode = Gtk.WrapMode.WORD;
        this.view.top_margin = 12;
        this.view.left_margin = 12;
        this.view.monospace = true;
        this.view.editable = false;

        var provider = new Gtk.CssProvider ();
        try {
            provider.load_from_data (STYLES, STYLES.length);

            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        } catch (GLib.Error e) {
            critical (e.message);
        }

        scroll.add (view);
    }

    private void choose_file () {
        Gtk.FileChooserDialog chooser = new Gtk.FileChooserDialog (
            "Open Text File",
            this,
            Gtk.FileChooserAction.OPEN,
            "_Cancel", Gtk.ResponseType.CANCEL,
            "_Open", Gtk.ResponseType.ACCEPT
        );

        Gtk.FileFilter filter = new Gtk.FileFilter ();
        chooser.set_filter (filter);
        filter.add_mime_type ("text/*");

        if (chooser.run () == Gtk.ResponseType.ACCEPT) {
            open_file (chooser.get_filename ());
        }

        chooser.close ();
    }

    private void open_file (string filename) {
        try {
            string text;
            FileUtils.get_contents (filename, out text);
            File file = File.new_for_path (filename);
            string basename = file.get_basename ();
            this.view.buffer.text = text;
            this.title = basename;
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }

    public static int main (string[] args) {
        Gtk.init (ref args);

        Application app = new Application ();
        app.show_all ();

        Gtk.main ();
        return 0;
    }
}
