#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "game.h"
#include "helpfield.h"
#include <QMainWindow>
#include <QGridLayout>

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private:
    GameField *m_gameField;
    HelpField *m_helpField;
    QGridLayout *m_gridLayout;
    QWidget *m_centralWidget;
};


#endif // MAINWINDOW_H
