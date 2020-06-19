#ifndef LOGINHANDLER_H
#define LOGINHANDLER_H

#include <QObject>
#include "network.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>

class LoginHandler : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(bool login READ isLogin WRITE setLogin NOTIFY loginChanged)

    explicit LoginHandler(QObject *parent = nullptr);

    bool isLogin() const;
    void setLogin(bool value);

public slots:
    bool tryLogin(const QString email, const QString password);
    bool trySingUp(const QString email, const QString password);
    void signOut();

private slots:
    void parseUserInfo(const QByteArray& data);
    void parseLogin(const QByteArray& data);
    void parseSignUp(const QByteArray& data);

signals:
    void loginChanged(bool);

private:
    bool login;
    Network networkrequest;
    QString tokenid, username;

    void fetchUserInfo();
};

#endif // LOGINHANDLER_H
