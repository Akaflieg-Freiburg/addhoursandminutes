/***************************************************************************
*   Copyright (C) 2019-2022 by Stefan Kebekus                             *
*   stefan.kebekus@math.uni-freiburg.de                                   *
*                                                                         *
*   This program is free software; you can redistribute it and/or modify  *
*   it under the terms of the GNU General Public License as published by  *
*   the Free Software Foundation; either version 3 of the License, or     *
*   (at your option) any later version.                                   *
*                                                                         *
*   This program is distributed in the hope that it will be useful,       *
*   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
*   GNU General Public License for more details.                          *
*                                                                         *
*   You should have received a copy of the GNU General Public License     *
*   along with this program; if not, write to the                         *
*   Free Software Foundation, Inc.,                                       *
*   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
***************************************************************************/

package de.akaflieg_freiburg.cavok.add_hours_and_minutes;

import android.content.*;
import android.os.*;
import android.view.*;


public class AndroidAdaptor extends org.qtproject.qt.android.bindings.QtActivity {
    private static AndroidAdaptor m_instance;
    private static Vibrator m_vibrator;
    public static native void onWindowSizeChanged();
    
    public AndroidAdaptor() 
    {
        m_instance = this;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
	
	// Be informed when the window size changes, and call the C++ method
	// onWindowSizeChanged() whenever it changes. The window size changes
	// when the user starts/end the split view mode, or when the user drags
	// the slider in order to adjust the relative size of the two windows
	// shown.
	View rootView = getWindow().getDecorView().getRootView();
	rootView.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
		@Override
		public void onLayoutChange(View view, int left, int top, int right, int bottom,
					   int oldLeft, int oldTop, int oldRight, int oldBottom) {
		    onWindowSizeChanged();
		}
	    });
	
        // Set fullscreen
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) 
        {
            getWindow().getAttributes().layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
        }
    }

    // Returns the bottom inset required to avoid system bars and display cutouts
    public static double windowHeight() {
	return m_instance.getWindow().getDecorView().getRootView().getHeight();
    }

    public static double windowWidth() {
	return m_instance.getWindow().getDecorView().getRootView().getWidth();
    }
    
    // Returns the bottom inset required to avoid system bars and display cutouts
    public static double safeInsetBottom() 
    {
        if (Build.VERSION.SDK_INT >= 30) {
            return m_instance.getWindow().getDecorView().getRootWindowInsets()
            .getInsets(WindowInsets.Type.systemBars()|WindowInsets.Type.displayCutout()).bottom;
        }

        return m_instance.getWindow().getDecorView().getRootWindowInsets().getSystemWindowInsetBottom();
    }

    // Returns the left inset required to avoid system bars and display cutouts
    public static double safeInsetLeft() 
    {
        if (Build.VERSION.SDK_INT >= 30)
        {
            return m_instance.getWindow().getDecorView().getRootWindowInsets()
            .getInsets(WindowInsets.Type.systemBars()|WindowInsets.Type.displayCutout()).left;
        }

        return m_instance.getWindow().getDecorView().getRootWindowInsets().getSystemWindowInsetLeft();
    }

    // Returns the right inset required to avoid system bars and display cutouts
    public static double safeInsetRight() 
    {
        if (Build.VERSION.SDK_INT >= 30)
        {
            return m_instance.getWindow().getDecorView().getRootWindowInsets()
            .getInsets(WindowInsets.Type.systemBars()|WindowInsets.Type.displayCutout()).right;
        }

        return m_instance.getWindow().getDecorView().getRootWindowInsets().getSystemWindowInsetRight();
    }

    // Returns the top inset required to avoid system bars and display cutouts
    public static double safeInsetTop() 
    {
        if (Build.VERSION.SDK_INT >= 30) {
            return m_instance.getWindow().getDecorView().getRootWindowInsets()
            .getInsets(WindowInsets.Type.systemBars()|WindowInsets.Type.displayCutout()).top;
        }

        return m_instance.getWindow().getDecorView().getRootWindowInsets().getSystemWindowInsetTop();
    }

    // Vibrate once, very briefly
    public static void vibrateBrief() 
    {
        if (m_vibrator == null)
        {
            m_vibrator = (Vibrator) m_instance.getSystemService(Context.VIBRATOR_SERVICE);
        }
        m_vibrator.vibrate(10);
    }

    // Vibrate once, for a longer period
    public static void vibrateError() 
    {
        if (m_vibrator == null)
        {
            m_vibrator = (Vibrator) m_instance.getSystemService(Context.VIBRATOR_SERVICE);
        }
        m_vibrator.vibrate(200);
    }
}
