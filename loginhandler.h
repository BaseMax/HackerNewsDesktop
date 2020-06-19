#ifndef LOGINHANDLER_H
#define LOGINHANDLER_H

#include <QObject>

class LoginHandler : public QObject
{
    Q_OBJECT
public:
    explicit LoginHandler(QObject *parent = nullptr);

signals:

};

#endif // LOGINHANDLER_H
