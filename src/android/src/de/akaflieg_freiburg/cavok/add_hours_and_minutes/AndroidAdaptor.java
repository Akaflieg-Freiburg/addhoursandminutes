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

import android.os.*;
import android.content.*;
import android.app.*;

import android.content.res.Resources;
import android.content.res.Configuration;
import android.util.DisplayMetrics;

import android.view.Display;
import android.view.Surface;
import android.view.View;
import android.view.DisplayCutout;
import android.view.Window;
import android.view.WindowManager;
import android.view.WindowInsets;
import android.graphics.Color;


import android.content.Context;
import android.os.Vibrator;

public class AndroidAdaptor extends org.qtproject.qt.android.bindings.QtActivity
{
    private static AndroidAdaptor m_instance;
    private static Vibrator m_vibrator;

    public AndroidAdaptor()
    {
        m_instance = this;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      setCustomStatusAndNavBar();
    } // onCreate

    void setCustomStatusAndNavBar() {
        //First check sdk version, custom/transparent System_bars are only available after LOLLIPOP
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();

            //The Window flag 'FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS' will allow us to paint the background of the status bar ourself and automatically expand the canvas
            //If you want to simply set a custom background color for the navbar, use the following addFlags call
//            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);

            //The Window flag 'FLAG_TRANSLUCENT_NAVIGATION' will allow us to paint the background of the navigation bar ourself
            //But we will also have to deal with orientation and OEM specifications, as the nav bar may or may not depend on the orientation of the device
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS | WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);

            window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);

            //Set Statusbar Transparent
            window.setStatusBarColor(Color.TRANSPARENT);
            //Statusbar background is now transparent, but the icons and text are probably white and not really readable, as we have a bright background color
            //We set/force a light theme for the status bar to make those dark
            View decor = window.getDecorView();
            decor.setSystemUiVisibility(decor.getSystemUiVisibility() | View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);

            //Set Navbar to desired color (0xAARRGGBB) set alpha value to 0 if you want a solid color
            window.setNavigationBarColor(0xFFD3D3D3);
        }
    }

    /* Vibrate once, very briefly */
    public static void vibrateBrief()
    {
        if (m_vibrator == null)
            m_vibrator = (Vibrator) m_instance.getSystemService(Context.VIBRATOR_SERVICE);
        m_vibrator.vibrate(10);
    }

    /* Vibrate once, for a longer period */   
    public static void vibrateError()
    {
        if (m_vibrator == null)
            m_vibrator = (Vibrator) m_instance.getSystemService(Context.VIBRATOR_SERVICE);
        m_vibrator.vibrate(200);
    }
}
