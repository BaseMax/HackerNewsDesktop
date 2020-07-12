#include "newsmodel.h"

NewsModel::NewsModel(QObject *parent)
    : QAbstractListModel(parent), loaded{false}, networkrequest(topstoriesapi),
      currentrequestnumber{0}, finalrequestnumber{10}
{

//    connect(&networkrequest, SIGNAL(complete(QByteArray&)), this, SLOT(parsePostId(QByteArray&)));
    connect(&networkrequest, &Network::complete, this, &NewsModel::parsePostId);
    networkrequest.get();
//    for (int i{0}; i < finalrequestnumber; ++i) {
//        networkrequest.setUrl(QUrl(postinfoapi.toString() + postid[i] + ".json"));
//        networkrequest.get();
//    }
}


int NewsModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return vlist.size();
}

QVariant NewsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || vlist.size() <= 0)
        return QVariant();

    QVariantList temp = vlist.at(index.row());
    const int column = role - (ROLE_START + 1);
    switch (role) {
        case authorRole:
            return temp[column];
        case urlRole:
            return temp[column];
        case titleRole:
            return temp[column];
        case dateRole:
            return temp[column];
        case commentRole:
            return temp[column];
        case pointRole:
            return temp[column];

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

Qt::ItemFlags NewsModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> NewsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    int column_number{0};
    for (int i{ROLE_START + 1}; i != ROLE_END; ++i, ++column_number) {
        roles.insert(i, this->columns[column_number]);
    }
    return roles;
}

bool NewsModel::insert(const int id, const QString& author, const QString& url,
                       const QString& title, const QString& date,
                       const int point, const int comment, const QModelIndex &parent)
{
    int rowcount = rowCount();
    beginInsertRows(parent, rowcount, rowcount);

    QVariantList temp;
    temp.append(id);
    temp.append(author);
    temp.append(url);
    temp.append(title);
    temp.append(date);
    temp.append(point);
    temp.append(comment);
    vlist.push_back(temp);
    endInsertRows();
    return true;
}

//bool NewsModel::prepareAndInsert(QString filepath)
//{
//    filepath.replace("file://", "");
//    QFileInfo info(filepath);
//    QStringList postfix{" B", " KB", " MB", " GB", " TB"};
//    qint64 size{info.size()};
//    if (size == 0) {
//        return false;
//    }
//    size_t i{0};
//    for (; i <= 4; ++i) {
//        if (size > 1024) {
//            size /= 1024;
//        }else {
//            break;
//        }
//    }
//    insert(info.fileName(), QString(QString::number(size) + postfix[i]), info.completeSuffix(), filepath);
//    return true;
//}

QStringList NewsModel::getFileInfo(int index) const
{
    QStringList fileinfo{vlist[index][3].toString(), vlist[index][0].toString()};
    return fileinfo;
}

QStringList NewsModel::get(int index)
{
    QStringList list;
    foreach (QVariant var, vlist[index]) {
        list.append(var.toString());
    }
    return list;
}

void NewsModel::parsePostId(const QByteArray &datas)
{
    disconnect(&networkrequest, &Network::complete, this, &NewsModel::parsePostId);
    connect(&networkrequest, &Network::complete, this, &NewsModel::parsePostInfo);
    QJsonDocument jsonresponse = QJsonDocument::fromJson(datas);
    QJsonArray jsonobject = jsonresponse.array();
    for (int i{0}; i < finalrequestnumber; ++i) {
        getPostInfo(jsonobject[i].toInt());
    }
}


void NewsModel::parsePostInfo(const QByteArray &data)
{
    QJsonDocument jsonresponse = QJsonDocument::fromJson(data);
    QJsonObject jsonobject = jsonresponse.object();
    QVariantList temp;
    int comments{0};
    QDateTime date;
    date.setSecsSinceEpoch(jsonobject["time"].toInt());
    if (jsonobject["kids"] != QJsonValue()) {
        comments = jsonobject["kids"].toArray().size();
    }

    insert(jsonobject["id"].toInt(), jsonobject["by"].toString(),
           jsonobject["url"].toString(),jsonobject["title"].toString(),
           date.toString("dd MMM hh:mm"), comments, jsonobject["score"].toInt());

    checkRequestJobDone();
}

void NewsModel::checkRequestJobDone()
{
    if (currentrequestnumber == finalrequestnumber - 1) {
        currentrequestnumber = 0;
        setLoaded(true);
        return;
    }
    ++currentrequestnumber;
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


bool NewsModel::getLoaded() const
{
    return loaded;
}

void NewsModel::setLoaded(bool value)
{
    if (loaded == value) {
        return;
    }
    loaded = value;
    emit loadedChanged(value);
}

void NewsModel::getPostInfo(int id)
{
//    qDebug() << "entered id to getPostInfo is: " << id;
//    qDebug() << "sending request to : " << postinfoapi.toString() + QString::number(id) + ".json";
    networkrequest.setUrl(QUrl(postinfoapi.toString() + QString::number(id) + ".json"));
    networkrequest.get();
}
