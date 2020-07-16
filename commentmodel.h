#ifndef CommentModel_H
#define CommentModel_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDateTime>
#include "network.h"
#include "commenttype.h"



class CommentModel : public QAbstractListModel
{
    Q_OBJECT

public:
    /*
     * roles for each column. ROLE_END is a flag for iteration convenience
     */
    enum {
        ROLE_START = Qt::UserRole + 1,
        idRole,
        authorRole,
        dateRole,
        textRole,
        indentRole,
        ROLE_END
    };

    Q_PROPERTY(bool loaded READ getLoaded WRITE setLoaded NOTIFY loadedChanged);

    explicit CommentModel(QObject *parent = nullptr);
    ~CommentModel();
    // return number of data's
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    // return data by role and index
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    // set data by role and index
//    bool setData(const QModelIndex &index, const QVariant &value,
//                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;
    QHash<int, QByteArray> roleNames() const override;
    bool insert(int id, int indent, const QString& author,
                const QString& date, const QString& text,
                const int cmparent);
    bool insert(const CommentType& data);
    bool getLoaded() const;
    void setLoaded(bool value);

    int getPostid() const;
    void setPostid(int value);

public slots:
    // remove an element by index
    //    bool remove(int index, const QModelIndex &parent = QModelIndex());
    void getCommentInfo();

private slots:
    void parseCommentInfo(const QByteArray& data);
//    void parsePostInfo(const QByteArray& data);
    void getCommentInfo(int id);

signals:
    void loadedChanged(const bool status);


private:
    void checkRequestJobDone();


    QList<CommentType*> vlist;
    // list of columns
    const QList<QByteArray> columns{"id", "author", "date", "text", "indent"};
    bool loaded;
    QUrl commentinfoapi{"https://hacker-news.firebaseio.com/v0/item/"};
    Network networkrequest;
    int currentrequestnumber;
    int finalrequestnumber;
    int postid;
};

#endif // CommentModel_H
