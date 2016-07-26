/**
 * Eiffel Forum License, version 2
 * 
 * 1. Permission is hereby granted to use, copy, modify and/or
 *    distribute this package, provided that:
 *       * copyright notices are retained unchanged,
 *       * any distribution of this package, whether modified or not,
 *         includes this license text.
 * 2. Permission is hereby also granted to distribute binary programs
 *    which depend on this package. If the binary program depends on a
 *    modified version of this package, you are encouraged to publicly
 *    release the modified version of this package.
 * 
 * THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT WARRANTY. ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE AUTHORS BE LIABLE TO ANY PARTY FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THIS PACKAGE.
 */
package org.eiffelgame2.app;
import org.libsdl.app.SDLActivity;
public class EiffelGame2Activity extends SDLActivity {

	/**
     * This method is called by Eiffel Game2 when loading the native libraries.
     * It can be overridden to provide names of shared libraries to be loaded.
     * An array returned by a new implementation must at least contain "SDL2"
	 * and "main". Also keep in mind that the order the libraries are loaded
	 * may matter ("main" should be the last one).
     * @return names of shared libraries to be loaded (e.g. "SDL2", "main").
     */
	@Override
    protected String[] getLibraries() {
        return new String[] {
            "SDL2",
            "SDL2_image",
            "SDL2_ttf",
			"SDL2_gfx",
			"FLAC",
			"ogg",
			"vorbis",
			"vorbis-stream",
			"sndfile",
			"openal",
            "main"
        };
    }
}
