#include "helpfield.h"

HelpField::HelpField() {

    setFixedSize(300, 50);
    m_text = "Your Score: 0 (Press Space to Pause)";
}

void HelpField::paintEvent(QPaintEvent *e)
{
    Q_UNUSED(e)
    QPainter painter;
    painter.begin(this);
    painter.drawRect(0,0,width()-1, height()-1);

    painter.setFont(QFont("Ubuntu",10,700));
    painter.drawText(QRect(0,0,width(),height()),Qt::AlignCenter,m_text);
    painter.end();
}

void HelpField::ChangeTextSlot(QString text)
{
    m_text = text;
    repaint();
}
