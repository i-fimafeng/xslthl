/*
 * xslthl - XSLT Syntax Highlighting
 * https://sourceforge.net/projects/xslthl/
 * Copyright (C) 2005-2008 Michal Molhanec, Jirka Kosek, Michiel Hendriks
 * 
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 * 
 * Michal Molhanec <mol1111 at users.sourceforge.net>
 * Jirka Kosek <kosek at users.sourceforge.net>
 * Michiel Hendriks <elmuerte at users.sourceforge.net>
 */
package net.sf.xslthl;

import java.util.Collection;
import java.util.HashSet;

/**
 * 
 */
public abstract class WholeHighlighter extends Highlighter {
    private Collection<String> styles = new HashSet<String>();
    private boolean emptyStyle = true;
    private boolean allStyles = false;

    void loadStyles(Params params) {
	if (!params.isSet("empty")) {
	    emptyStyle = false;
	}
	if (params.isSet("all")) {
	    allStyles = true;
	    return;
	}
	params.getMutliParams("style", styles);
    }

    boolean appliesOnEmptyStyle() {
	return emptyStyle;
    }

    boolean appliesOnAllStyles() {
	return allStyles;
    }

    boolean appliesOnStyle(String style) {
	return styles.contains(style);
    }

    public void init(Params params) throws HighlighterConfigurationException {
	super.init(params);
	if (params != null && params.isSet("applyOnStyles")) {
	    loadStyles(params.getParams("applyOnStyles"));
	}
    }

}
