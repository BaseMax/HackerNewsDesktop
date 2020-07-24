#ifndef LOGINHANDLER_H
#define LOGINHANDLER_H

#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include "network.h"

class LoginHandler : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(bool login READ isLogin WRITE setLogin NOTIFY loginChanged)
    Q_PROPERTY(QString username READ getUsername WRITE setUsername NOTIFY usernameChanged)

    explicit LoginHandler(QObject *parent = nullptr);

    bool isLogin() const;
    void setLogin(bool value);

    QString getUsername() const;
    void setUsername(const QString &value);

public slots:
    bool tryLogin(const QString email, const QString password);
    bool trySignUp(const QString username, const QString email, const QString password);
    void signOut();

private slots:
    void parseUserInfo(const QByteArray& data);
    void parseLogin(const QByteArray& data);
    void parseSignUp(const QByteArray& data);

signals:
    void loginChanged(bool);
    void usernameChanged();

private:
    bool login;
    Network networkrequest;
    QString tokenid, username;

    void fetchUserInfo();
};

#endif // LOGINHANDLER_H
