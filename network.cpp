#include "network.h"
#include <QDebug>

Network::Network(QObject *parent) : QObject(parent), byteheaders{"", ""}
{
    connect(&netaccman, SIGNAL(finished(QNetworkReply*)), this, SLOT(finished(QNetworkReply*)));
}

Network::Network(QUrl url, QObject *parent) : QObject(parent), url{url}, byteheaders{"", ""}
{
    connect(&netaccman, SIGNAL(finished(QNetworkReply*)), this, SLOT(finished(QNetworkReply*)));
}

QHash<QByteArray, QByteArray> Network::getHeaders() const
{
    return headers;
}

void Network::setHeaders(const QHash<QByteArray, QByteArray> &value)
{
    headers = value;
    updateByteHeader();
}

QUrl Network::getUrl() const
{
    return url;
}

void Network::setUrl(const QUrl &value)
{
    url = value;
}

void Network::addHeader(const QByteArray &header, const QByteArray &value)
{
    this->headers[header] = value;
    updateByteHeader();
}

bool Network::post(const QByteArray& data)
{
    QNetworkRequest request(this->url);
    request.setRawHeader(byteheaders[0], byteheaders[1]);
    QNetworkReply *reply = netaccman.post(request, data);
    return reply->error() == QNetworkReply::NoError;
}

bool Network::get()
{
    QNetworkRequest request(this->url);
    request.setRawHeader(byteheaders[0], byteheaders[1]);
    QNetworkReply* reply = netaccman.get(request);
    return reply->error() == QNetworkReply::NoError;
}

void Network::finished(QNetworkReply* reply)
{
    emit complete(reply->readAll());
}

void Network::updateByteHeader()
{
    QHash<QByteArray, QByteArray>::const_iterator it = headers.constBegin();
    QString key, value;
    while (it != headers.constEnd()) {
        key += it.key();
        value += it.value();
        ++it;
    }
    byteheaders[0] = key.toUtf8();
    byteheaders[1] = value.toUtf8();
}
