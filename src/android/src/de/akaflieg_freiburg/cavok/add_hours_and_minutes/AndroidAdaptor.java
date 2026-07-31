/***************************************************************************
*   Copyright (C) 2019-2025 by Stefan Kebekus                             *
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
import android.content.res.*;
import android.os.*;
import android.view.*;


public class AndroidAdaptor extends org.qtproject.qt.android.bindings.QtActivity
{
  private static Context m_context;
  private static Vibrator m_vibrator;

  @Override
  public void onCreate(Bundle savedInstanceState)
  {
    super.onCreate(savedInstanceState);
    m_context = getApplicationContext();
  }

  @Override
  public void setContentView(View view, ViewGroup.LayoutParams params)
  {
    super.setContentView(view, params);
    // Qt calls this method from QtActivityDelegate.setUpLayout() and applies
    // its own status bar appearance right afterwards, so post rather than call
    // directly.
    new Handler(Looper.getMainLooper()).post(this::setLightStatusBarIcons);
  }

  @Override
  public void onConfigurationChanged(Configuration newConfig)
  {
    super.onConfigurationChanged(newConfig);
    setLightStatusBarIcons();
  }

  // The status bar sits on the teal toolbar, which is dark in both color
  // schemes, so the status bar icons must always be light. The theme attribute
  // windowLightStatusBar cannot express this: Qt overrides it to match the
  // system color scheme on startup and on every light/dark change
  // (QtActivityDelegateBase.handleUiModeChange()), so the appearance is
  // re-applied after each of these points.
  @SuppressWarnings("deprecation")
  private void setLightStatusBarIcons()
  {
    Window window = getWindow();
    if (window == null)
    {
      return;
    }
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R)
    {
      WindowInsetsController controller = window.getInsetsController();
      if (controller != null)
      {
        controller.setSystemBarsAppearance(0, WindowInsetsController.APPEARANCE_LIGHT_STATUS_BARS);
      }
    }
    else
    {
      View decor = window.getDecorView();
      decor.setSystemUiVisibility(decor.getSystemUiVisibility() & ~View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
    }
  }

  // Vibrate once, very briefly
  public static void vibrateBrief()
  {
    vibrate(10);
  }

  // Vibrate once, for a longer period
  public static void vibrateError()
  {
    vibrate(200);
  }

  private static void vibrate(long milliseconds)
  {
    if (m_vibrator == null)
    {
      if (m_context == null)
      {
        return;
      }
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
      {
        VibratorManager manager = (VibratorManager) m_context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE);
        if (manager != null)
        {
          m_vibrator = manager.getDefaultVibrator();
        }
      }
      else
      {
        m_vibrator = (Vibrator) m_context.getSystemService(Context.VIBRATOR_SERVICE);
      }
    }
    if (m_vibrator == null || !m_vibrator.hasVibrator())
    {
      return;
    }
    m_vibrator.vibrate(VibrationEffect.createOneShot(milliseconds, VibrationEffect.DEFAULT_AMPLITUDE));
  }
}
