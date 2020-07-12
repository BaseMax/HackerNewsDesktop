#include "loginhandler.h"
#include <QDebug>

LoginHandler::LoginHandler(QObject *parent) : QObject(parent), login{false}
{
//    QHash <QByteArray, QByteArray> headers;
//    headers["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64; rv:77.0) Gecko/20100101 Firefox/77.0";
//    headers["Accept"] = "*/*";
//    headers["Accept-Language"] = "en-US,en;q=0.5";
//    headers["Content-Type"] = "application/json";
//    headers["X-Client-Version"] = "Firefox/JsCore/6.6.2/FirebaseCore-web";
//    headers["Origin"] = "https://hacker-news-beta.now.sh";
//    headers["Referer"] = "https://hacker-news-beta.now.sh/login";
//    headers["TE"] = "Trailers";
//    headers["Connection"] = "keep-alive";
//    networkrequest.setHeaders(headers);
}

bool LoginHandler::isLogin() const
{
    return login;
}

void LoginHandler::setLogin(bool value)
{
    login = value;
    emit loginChanged(value);
}

bool LoginHandler::tryLogin(const QString email, const QString password)
{
    if (email.trimmed() == "" || password.trimmed() == "") {
        return false;
    }
    QByteArray data = (QString("email=") + email + QString("&password=") + password + QString("&returnSecureToken=true")).toUtf8();
    connect(&networkrequest, &Network::complete, this, &LoginHandler::parseLogin);
    QString url = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyAX9GJ9iWws_OHxHRp1NJQkW84YKGDSOzo";
    networkrequest.setUrl(url);
    return networkrequest.post(data);
}

bool LoginHandler::trySingUp(const QString email, const QString password)
{
    if (email.trimmed() == "" || password.trimmed() == "") {
        return false;
    }
    QByteArray data = (QString("email=") + email + QString("&password=") + password + QString("&returnSecureToken=true")).toUtf8();
    connect(&networkrequest, &Network::complete, this, &LoginHandler::parseSignUp);
    QString url = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyAX9GJ9iWws_OHxHRp1NJQkW84YKGDSOzo";
    networkrequest.setUrl(url);
    return networkrequest.post(data);
}

void LoginHandler::parseLogin(const QByteArray& data)
{
    disconnect(&networkrequest, &Network::complete, this, &LoginHandler::parseLogin);
    QJsonDocument jsonresponse = QJsonDocument::fromJson(data);
    QJsonObject jsonobject = jsonresponse.object();
    if (jsonobject["idToken"] != QJsonValue()) {
        tokenid = jsonobject["idToken"].toString();
        setLogin(true);
        fetchUserInfo();
        return;
    }

    setLogin(false);
}

void LoginHandler::parseSignUp(const QByteArray& data)
{
    disconnect(&networkrequest, &Network::complete, this, &LoginHandler::parseSignUp);
    QJsonDocument jsonresponse = QJsonDocument::fromJson(data);
    QJsonObject jsonobject = jsonresponse.object();
    if (jsonobject["idToken"] != QJsonValue()) {
        tokenid = jsonobject["idToken"].toString();
        setLogin(true);
        fetchUserInfo();
        return;
    }
    setLogin(false);
}

void LoginHandler::signOut()
{
    setLogin(false);
    tokenid = username = "";
}

void LoginHandler::parseUserInfo(const QByteArray &data)
{
    disconnect(&networkrequest, &Network::complete, this, &LoginHandler::parseUserInfo);
    QJsonDocument jsonresponse = QJsonDocument::fromJson(data);
    QJsonObject jsonobject = jsonresponse.object();
    jsonobject = (jsonobject["users"].toArray())[0].toObject();
    username = jsonobject["displayName"].toString();
}

void LoginHandler::fetchUserInfo()
{
    QByteArray data = (QString("idToken=") + tokenid).toUtf8();
    connect(&networkrequest, &Network::complete, this, &LoginHandler::parseUserInfo);
    QString url = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=AIzaSyAX9GJ9iWws_OHxHRp1NJQkW84YKGDSOzo";
    networkrequest.setUrl(url);
    networkrequest.post(data);
}


