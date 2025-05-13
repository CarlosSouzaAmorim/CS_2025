@LAZYGLOBAL OFF.
//c3_widget.ks
// 0 funcoes: 36 linhas

//uses: BLAH25555
RUNONCEPATH("TabWidget/tabwidget").

// ====    FUNCOES PARA widgets DA NAVE =============================================================================

// FUNCOES PARA widgets NA NAVE =====================================================================================


LOCAL gui IS GUI(500).
LOCAL tabwidget IS AddTabWidget(gui).

LOCAL page IS AddTab(tabwidget,"One").
page:ADDLABEL("This is page 1").
page:ADDLABEL("Put stuff here!").

LOCAL page IS AddTab(tabwidget,"Two").
page:ADDLABEL("This is page 2").
page:ADDLABEL("Put more stuff here!").

LOCAL page IS AddTab(tabwidget,"Three").
page:ADDLABEL("This is page 3").
page:ADDLABEL("Put even stuff here!").

ChooseTab(tabwidget,1).

LOCAL close IS gui:ADDBUTTON("Close").
gui:SHOW().
UNTIL close:PRESSED {
    // Handle processing of all the widgets on all the tabs.
    WAIT(0).
}
gui:HIDE().



