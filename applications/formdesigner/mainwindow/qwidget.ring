/*
**	Project : Form Designer 
**	File Purpose :  QWidget
**	Date : 2017.04.29
**	Author :  Mahmoud Fayed <msfclipper@yahoo.com>
*/

package formdesigner

class FormDesigner_QWidget from QWidget

	cBackColor = ""
	oSubWindow
	nX=0 nY=0		# for Select/Draw
	cWindowFlags = ""
	cMainLayout = ""
	cWindowIcon = ""
	cMenubar = ""
	nMenubarCounter = [0,0]	# For [Menus,Items] Names

	func BackColor
		return cBackColor

	func setBackColor cValue
		cBackColor=cValue
		updatestylesheets()

	func updatestylesheets
		setstylesheet("background-color:"+cBackColor+";")

	func setSubWindow oObject
		oSubWindow = oObject

	func WindowFlagsValue
		return cWindowFlags

	func SetWindowFlagsValue cValue
		cWindowFlags = cValue

	func MainLayoutValue
		return cMainLayout

	func SetMainLayoutValue cValue
		cMainLayout = cValue

	func WindowIconValue
		return cWindowIcon

	func SetWindowIconValue cValue
		cWindowIcon = cValue

	func MenubarValue
		return cMenubar

	func SetMenubarValue cValue
		cMenubar = cValue

	func AddObjectProperties  oDesigner
		oDesigner.oView.AddProperty("X",False)
		oDesigner.oView.AddProperty("Y",False)
		oDesigner.oView.AddProperty("Width",False)
		oDesigner.oView.AddProperty("Height",False)
		oDesigner.oView.AddProperty("Title",False)
		oDesigner.oView.AddProperty("Back Color",True)
		oDesigner.oView.AddProperty("Window Flags",True)
		oDesigner.oView.AddProperty("Set Layout",False)
		oDesigner.oView.AddProperty("Window Icon",True)
		oDesigner.oView.AddProperty("Menubar",True)

	func UpdateProperties oDesigner,nRow,nCol,cValue
		if nCol = 1 {
			switch nRow {
				case 0 	# x
					oSubWindow.move(0+cValue,oSubWindow.y())
				case 1 	# y
					oSubWindow.move(oSubWindow.x(),0+cValue)
				case 2	# width
					oSubWindow.resize(0+cValue,oSubWindow.height())
				case 3 	# height
					oSubWindow.resize(oSubWindow.width(),0+cValue)
				case 4  	# Title
					setWindowTitle(cValue)
				case 5	# back color
					setBackColor(cValue)
				case 6	# Window Flags
					setWindowFlagsValue(cValue)
				case 7  	# Main Layout
					setMainLayoutValue(cValue)
				case 8  	# Window Icon
					setWindowIconValue(cValue)
				case 9	# Menubar
					setMenubarValue(cValue)

			}
		}

	func DisplayProperties oDesigner
		oPropertiesTable = oDesigner.oView.oPropertiesTable
		oPropertiesTable.Blocksignals(True)
		# Set the X
			oPropertiesTable.item(0,1).settext(""+oSubWindow.x())
		# Set the Y
			oPropertiesTable.item(1,1).settext(""+oSubWindow.y())
		# Set the Width
			oPropertiesTable.item(2,1).settext(""+oSubWindow.width())
		# Set the Height
			oPropertiesTable.item(3,1).settext(""+oSubWindow.height())
		# Set the Title
			oPropertiesTable.item(4,1).settext(windowtitle())
		# Set the BackColor
			oPropertiesTable.item(5,1).settext(backcolor())
		# Set the Window Flags
			oPropertiesTable.item(6,1).settext(WindowFlagsValue())
		# Set the Main Layout
			oPropertiesTable.item(7,1).settext(MainLayoutValue())
		# Set the Window Icon
			oPropertiesTable.item(8,1).settext(WindowIconValue())
		# Set the Menubar
			oPropertiesTable.item(9,1).settext(MenubarValue())
		oPropertiesTable.Blocksignals(False)

	func DialogButtonAction oDesigner,nRow
		switch nRow {
			case 5 	# Back Color
				cColor = oDesigner.oGeneral.SelectColor()
				setBackColor(cColor)
				DisplayProperties(oDesigner)
			case 6	# Window Flags
				open_window(:WindowFlagsController)
				Last_Window().setParentObject(oDesigner)
			case 8	# Window Icon
				cFile = oDesigner.oGeneral.SelectFile(oDesigner)
				setWindowIconValue(cFile)
				DisplayProperties(oDesigner)
			case 9	# Menubar
				open_window(:MenubarDesignerController)
				Last_Window().setParentObject(oDesigner)
				Last_Window().setMenubar(MenubarValue())
		}

	func MousePressAction oDesigner
		# 8, 6 to start drawing from the center of the Mouse Cursor
			nX = oDesigner.oView.oFilter.getglobalx() - 8
			ny = oDesigner.oView.oFilter.getglobaly() - 6
		oDesigner.oView.oLabelSelect.raise()
		oDesigner.oView.oLabelSelect.resize(1,1)
		oDesigner.oView.oLabelSelect.show()

	func MouseReleaseAction oDesigner
		oDesigner.oView.oLabelSelect.hide()
		aRect = GetRectDim(oDesigner)
		oDesigner.SelectDrawAction(aRect)

	func MouseMoveAction oDesigner
		aRect = GetRectDim(oDesigner)
		oDesigner.oView.oLabelSelect {
			move(aRect[1],aRect[2])
			resize(aRect[3],aRect[4])
		}

	func GetRectDim oDesigner
		C_TOPMARGIN = 25
		nX2 = oDesigner.oView.oFilter.getglobalx()
		ny2 = oDesigner.oView.oFilter.getglobaly()
		top = min(nY2,nY) - oDesigner.oView.oArea.y() - oSubWindow.y() - y() - C_TOPMARGIN - oDesigner.oView.win.y()
		left = min(nX2,nX) - oDesigner.oView.oArea.x()  - oSubWindow.x() - x() - oDesigner.oView.win.x()
		width = max(nX,nX2) - min(nX,nX2)
		height = max(nY,nY2) - min(nY,nY2)
		return [left,top,width,height]

	func ObjectDataAsString oDesigner,nTabsCount
		cTabs = copy(char(9),nTabsCount)
		cOutput = cTabs + " :x = #{f1} , : y = #{f2}  , " + nl
		cOutput += cTabs + " :width =  #{f3} , :height = #{f4} , " + nl
		cOutput += cTabs + ' :title =  "#{f5}" , ' + nl
		cOutput += cTabs + ' :backcolor =  "#{f6}" , ' + nl
		cOutput += cTabs + ' :windowflags =  "#{f7}" , ' + nl
		cOutput += cTabs + ' :mainlayout =  "#{f8}" ,' + nl
		cOutput += cTabs + ' :WindowIcon =  "#{f9}" , ' + nl
		cOutput += cTabs + ' :Menubar =  "#{f10}"  ' + nl
		cOutput = substr(cOutput,"#{f1}",""+parentwidget().x())
		cOutput = substr(cOutput,"#{f2}",""+parentwidget().y())
		cOutput = substr(cOutput,"#{f3}",""+parentwidget().width())
		cOutput = substr(cOutput,"#{f4}",""+parentwidget().height())
		cOutput = substr(cOutput,"#{f5}",windowtitle())
		cOutput = substr(cOutput,"#{f6}",backcolor())
		cOutput = substr(cOutput,"#{f7}",WindowFlagsValue())
		cOutput = substr(cOutput,"#{f8}",MainLayoutValue())
		cOutput = substr(cOutput,"#{f9}",WindowIconValue())
		cOutput = substr(cOutput,"#{f10}",MenubarValue())
		return cOutput

	func GenerateCode oDesigner
		cOutput = char(9) + char(9) +
		'move(#{f1},#{f2})
		resize(#{f3},#{f4})
		setWindowTitle("#{f5}")
		setstylesheet("background-color:#{f6};") ' + nl
		if not WindowFlagsValue() = NULL {
			cOutput += '
		setWindowFlags(#{f7}) ' + nl
		}
		if not WindowIconValue() = NULL {
			cOutput += '
		setWinIcon(win,"#{f8}") ' + nl
		}
		if not MenubarValue() = NULL {
			cOutput += '
		#{f9} ' + nl
		}
		cOutput = substr(cOutput,"#{f1}",""+parentwidget().x())
		cOutput = substr(cOutput,"#{f2}",""+parentwidget().y())
		cOutput = substr(cOutput,"#{f3}",""+parentwidget().width())
		cOutput = substr(cOutput,"#{f4}",""+parentwidget().height())
		cOutput = substr(cOutput,"#{f5}",windowtitle())
		cOutput = substr(cOutput,"#{f6}",backcolor())
		cOutput = substr(cOutput,"#{f7}",WindowFlagsValue())
		cOutput = substr(cOutput,"#{f8}",WindowIconValue())
		cOutput = substr(cOutput,"#{f9}",MenubarCode())
		return cOutput

	func GenerateCodeAfterObjects oDesigner
		cOutput = ""
		if not MainLayoutValue() = NULL {
			cOutput += '
		setLayout(#{f1}) ' + nl
			cOutput = substr(cOutput,"#{f1}",MainLayoutValue())
		}
		return cOutput

	func MenubarCode
		if MenubarValue() = NULL { return }
		cCode = GenerateMenubarCode(MenubarValue())
		return cCode

	func GenerateMenubarCode cMenu
		eval(cMenu)
		nMenubarCounter = [0,0]
		cCode = "oMenuBar = new qmenubar(win) {" + nl
		aChild = aMenuData[:Children]
		if len(aChild) > 0 {
			cCode += GenerateSubMenuCode(aChild)
		}
		cCode += Copy(Char(9),2) +  "}" + nl
		cCode += Copy(Char(9),2) + "win.SetMenuBar(oMenuBar)" + nl
		return cCode

	func GenerateSubMenuCode aChild
		nMenubarCounter[2]=0
		nMenuID = nMenubarCounter[1]
		cCode = ""
		for Item in aChild {
			nMenubarCounter[2]++
			if ( len(Item[:Children]) > 0 ) or (nMenuID = 0) {
				# Menu
				nMenubarCounter[1]++
				nMenuID2 = nMenubarCounter[1]
				cTempCode = Copy(Char(9),3) + 'subMenu#{f1} = addmenu("#{f2}")' + nl
				cTempCode += Copy(Char(9),3) + 'subMenu#{f1} {' + nl
				cTempCode += GenerateSubMenuCode(Item[:Children])
				cTempCode += Copy(Char(9),3) + '}' + nl
				cTempCode = SubStr(cTempCode,"#{f1}",""+nMenuID2)
				cTempCode = SubStr(cTempCode,"#{f2}",Item[:Text])
				cCode += cTempCode
			else
				# Action
				cTempCode = `
				oAction#{f5}_#{f6} = new qAction(win) {
					setShortcut(new QKeySequence("#{f1}"))
					setbtnimage(self,"#{f2}")
					settext("#{f3}")
					setclickevent(Method(:#{f4}))
				}
				addaction(oAction#{f5}_#{f6})`+nl
				cTempCode = SubStr(cTempCode,"#{f1}",Item[:ShortCut])
				cTempCode = SubStr(cTempCode,"#{f2}",Item[:Image])
				cTempCode = SubStr(cTempCode,"#{f3}",Item[:Text])
				if Item[:Action] = NULL {
					Item[:Action] = "NoAction"
				}
				cTempCode = SubStr(cTempCode,"#{f4}",Item[:Action])
				cTempCode = SubStr(cTempCode,"#{f5}",""+nMenubarCounter[1])
				cTempCode = SubStr(cTempCode,"#{f6}",""+nMenubarCounter[2])
				cCode += cTempCode
			}
		}
		return cCode
