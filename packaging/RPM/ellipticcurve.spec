#
# spec file for package ellipticcurve (Version ${PROJECT_VERSION})
#
# Copyright (c) ${COPYRIGHTYEAR} Stefan Kebekus <stefan.kebekus@math.uni-freiburg.de>
#
#   This file is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the
#   Free Software Foundation, Inc.,
#   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
# Please submit bugfixes or comments to stefan.kebekus@math.uni-freiburg.de
#

Name:           ellipticcurve

BuildRequires:  cmake gcc-c++
%if %{defined suse_version}
BuildRequires:  update-desktop-files
%endif
%if %{defined fedora_version}
BuildRequires:  qt5-qtbase-devel qt5-qtsvg-devel qt5-linguist
%else
BuildRequires:  libqt5-qtbase-devel libqt5-qtsvg-devel libqt5-linguist libqt5-linguist-devel libqt5-qttools
%endif

License:        GPLv3+
Group:          Amusements/Teaching/Mathematics
Summary:        Sketches elliptic curves and allows to experiment with their group law
Version:        ${PROJECT_VERSION}
Release:        1.0
Url:            https://cplx.vm.uni-freiburg.de/en/ecp-en
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source:         %{name}-%version.tar.gz



%description 
The Elliptic Curve Plotter is a graphical application that allows the user to
play and experiment with elliptic curves and their group law.

    
%prep 
%setup -q 
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=$RPM_BUILD_ROOT/usr -DCMAKE_BUILD_TYPE=Debug

%build
cd build
make


%install
cd build
make install
%if %{defined suse_version}
%suse_update_desktop_file de.unifreiburg.ellipticcurve Math
%endif


%post
%if %{defined fedora_version}
%update_menus
%endif
echo #avoid rpmlint warning on openSUSE systems


%postun
%if %{defined fedora_version}
%clean_menus
%endif
echo #avoid rpmlint warning on openSUSE systems


%clean
rm -rf $RPM_BUILD_ROOT

%files 
%defattr(-,root,root)
/usr/bin/ellipticcurve
/usr/share/applications/de.unifreiburg.ellipticcurve.desktop
/usr/share/metainfo/de.unifreiburg.ellipticcurve.appdata.xml
/usr/share/icons/hicolor/scalable
/usr/share/man/man1/*

%changelog
* Sun Oct 28 2018 Stefan Kebekus <stefan.kebekus@math.uni-freiburg.de> ${PROJECT_VERSION}-1.0
- RPM Release

