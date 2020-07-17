#include "commentmodel.h"

CommentModel::CommentModel(QObject *parent)
    : QAbstractListModel(parent), loaded{false}, repliesloaded{false},
      currentrequestnumber{0}, finalrequestnumber{0}
{
    postid = 23855208;
//    CommentType* d = new CommentType(1, 0, 0, "SeedPuller", "1 Day Ago", "this is my text", std::vector<int>{2});
//    CommentType* e = new CommentType(2, 1, 20, "SeedPuller", "1 Day Ago", "this is my reply", std::vector<int>());
//    CommentType* f = new CommentType(3, 0, 0, "SeedPuller", "1 Day Ago", "this is my text", std::vector<int>());
//    insert(*d);
//    insert(*e);
//    insert(*f);
    getPostComments();
}

CommentModel::~CommentModel()
{
    for (CommentType* object : *vlist) {
        delete object;
        object = nullptr;
    }
    delete vlist;
}


int CommentModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return vlist->size();
}

QVariant CommentModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || vlist->size() <= 0)
        return QVariant();

    const CommentType* temp = vlist->at(index.row());
    if (temp == nullptr) {
        qDebug() << "null";
        return QVariant();
    }
    switch (role) {
        case idRole:
            return temp->getId();
            break;
        case authorRole:
            return temp->getAuthor();
            break;
        case textRole:
            return temp->getText();
            break;
        case dateRole:
            return temp->getDate();
            break;
        case indentRole:
            return temp->getIndent();
            break;
        case childsRole:
            return temp->childsNumber();
            break;

    }
    return QVariant();
}


//bool Model::setData(const QModelIndex &index, const QVariant &value, int role)
//{
//    int indexrow = index.row();
//    if (data(index, role) != value && vlist.size() > indexrow) {

//        switch (role) {

//            case fnameRole:
//                vlist[indexrow][1] = value.toString();
//            break;
//            case debtRole:
//                vlist[indexrow][2] = value.toString();
//            break;
//            case picRole:
//                vlist[indexrow][3] = value.toString();
//            break;
//        }
//        emit dataChanged(index, index, QVector<int>() << role);
//        return true;
//    }
//    return false;
//}

Qt::ItemFlags CommentModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> CommentModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    int column_number{0};
    for (int i{ROLE_START + 1}; i != ROLE_END; ++i, ++column_number) {
        roles.insert(i, this->columns[column_number]);
    }
    return roles;
}

bool CommentModel::insert(int id, int indent, const QString& author,
                          const QString& date, const QString& text,
                          const int cmparent)
{
    CommentType* data = new CommentType(id, cmparent, indent, author, date, text, std::vector<int>());
    return insert(*data);
}

// need some change to return more meaningful value
bool CommentModel::insert(const CommentType& data)
{
    int parent = data.getParent(), position{1};
    if (parent == 0) {
        position = vlist->size();
    } else {
        for (CommentType* cm: *vlist) {
            if (cm->getId() == parent) {
                break;
            }
            ++position;
        }
    }

    beginInsertRows(QModelIndex(), position, position);
    vlist->insert(position, const_cast<CommentType*>(&data));
    endInsertRows();

    return true;
}

void CommentModel::parseCommentInfo(const QByteArray &data)
{
    qDebug() << data;
    QJsonDocument jsonresponse = QJsonDocument::fromJson(data);
    QJsonObject jsonobject = jsonresponse.object();
    int parent{0};
    int indent{0};
    const int id{jsonobject["id"].toInt()};
    QDateTime date;
    std::vector<int> childs;
    CommentType* comment;
    QString text{jsonobject["text"].toString()};
    // decoding html entities
    QTextDocument textdoc;

    if (jsonobject["parent"].toInt() != postid) {
        // entering this condition means this function has been called through getReplies
        // so we have repliesindex available(getReplies function had filled it)
        parent = jsonobject["parent"].toInt();
        indent = vlist->at(repliesindex[id])->getIndent() + 20;
    }

    if (jsonobject["deleted"] != QJsonValue()) {
        if (parent == 0) {
             checkRequestJobDone(false);
        } else {
            checkRequestJobDone(true);
        }
        return;
    }

    textdoc.setHtml(text);
    // i don't know what "p, li { white-space: pre-wrap; }" is. i just removed it.
    text = textdoc.toHtml().replace("p, li { white-space: pre-wrap; }", "");

    date.setSecsSinceEpoch(jsonobject["time"].toInt());



    if (jsonobject["kids"] != QJsonValue()) {
        QJsonArray kids = jsonobject["kids"].toArray();
        for (QJsonValue child: kids) {
            childs.push_back(child.toInt());
        }
    }

    comment = new CommentType(id, parent, indent, jsonobject["by"].toString(), date.toString("dd MMM hh:mm"), text, childs);
    insert(*comment);

    if (parent == 0) {
         checkRequestJobDone(false);
    } else {
        checkRequestJobDone(true);
    }
}

void CommentModel::parsePostComments(const QByteArray &data)
{
    disconnect(&networkrequest, &Network::complete, this, &CommentModel::parsePostComments);
    connect(&networkrequest, &Network::complete, this, &CommentModel::parseCommentInfo);
    QJsonDocument jsonresponse = QJsonDocument::fromJson(data);
    QJsonObject jsonobject = jsonresponse.object();
    QJsonArray kids = jsonobject["kids"].toArray();
    for (QJsonValue cmid: kids) {
        getCommentInfo(cmid.toInt());
    }
}



void CommentModel::getCommentInfo(int id)
{
    ++finalrequestnumber;
    networkrequest.setUrl(QUrl(commentinfoapi.toString() + QString::number(id) + ".json"));
    networkrequest.get();
}

void CommentModel::getPostComments()
{
    vlist = new QList<CommentType*>();
    setLoaded(false);
    disconnect(&networkrequest, &Network::complete, this, &CommentModel::parseCommentInfo);
    connect(&networkrequest, &Network::complete, this, &CommentModel::parsePostComments);
    networkrequest.setUrl(QUrl(commentinfoapi.toString() + QString::number(postid) + ".json"));
    networkrequest.get();
}

void CommentModel::getReplies(int index, int id)
{
    if (index < 0 || index >= vlist->size()) {
        return;
    }
    CommentType* item = vlist->operator[](index);
    for (int child: item->getChilds()) {
        ++finalrequestnumber;
        repliesindex[id] = index;
        networkrequest.setUrl(QUrl(commentinfoapi.toString() + QString::number(child) + ".json"));
        networkrequest.get();
    }
}

void CommentModel::checkRequestJobDone(bool replyMode)
{
    ++currentrequestnumber;
    qDebug() << currentrequestnumber << "||" << finalrequestnumber;
    if (currentrequestnumber == finalrequestnumber) {
        finalrequestnumber = 0;
        currentrequestnumber = 0;
        if (replyMode) {
            setRepliesloaded(true);
            return;
        }
        setLoaded(true);
        return;
    }
}

int CommentModel::getPostId() const
{
    return postid;
}

void CommentModel::setPostId(int value)
{
    postid = value;
    emit postIdChanged();
}


//bool Model::remove(int index, const QModelIndex& parent) {
////        qDebug() << "removing index number: " << index;
//        beginRemoveRows(parent, index, index);
//        if (!removeRow(vlist[index][0].toInt())) {
//            qDebug() << db.getError();
//        }
//        vlist.removeAt(index);
//        endRemoveRows();
//        return true;
//}


bool CommentModel::getLoaded() const
{
    return loaded;
}

void CommentModel::setLoaded(bool value)
{
    if (loaded == value) {
        return;
    }
    loaded = value;
    emit loadedChanged(value);
}

bool CommentModel::getRepliesloaded() const
{
    return repliesloaded;
}

void CommentModel::setRepliesloaded(bool value)
{
    if (repliesloaded == value) {
        return;
    }
    repliesloaded = value;
    emit repliesLoadedChanged();
}

void CommentModel::reset()
{
    disconnect(&networkrequest, &Network::complete, this, &CommentModel::parseCommentInfo);
    disconnect(&networkrequest, &Network::complete, this, &CommentModel::parsePostComments);
    for (CommentType* object : *vlist) {
        delete object;
    }
    delete vlist;
    vlist = nullptr;
    setLoaded(false);
    setRepliesloaded(false);
    // insert replies index for deleting
}
