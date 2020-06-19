#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include "newsmodel.h"
#include "loginhandler.h"
//#include <commentmodel.h>

int main(int argc, char *argv[])
{
    qmlRegisterType<NewsModel>("API.NewsModel", 0, 1, "NewsModel");
    qmlRegisterType<LoginHandler>("API.LoginHandler", 0, 1, "LoginHandler");
//    qmlRegisterType<CommentModel>("API.CommentModel", 0, 1, "CommentModel");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
