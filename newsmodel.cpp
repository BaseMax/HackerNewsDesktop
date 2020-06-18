#include "model.h"
#include <QDebug>

Model::Model(QObject *parent)
    : QAbstractListModel(parent)
{
}

int Model::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return vlist.size();
}

QVariant Model::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || vlist.size() <= 0)
        return QVariant();

    QVariantList temp = vlist.at(index.row());
    switch (role) {
        case pathRole:
            return temp[0];
        case sizeRole:
            return temp[1];
        case typeRole:
            return temp[2];
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

Qt::ItemFlags Model::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> Model::roleNames() const
{
    QHash<int, QByteArray> roles;
    int column_number{0};
    for (int i{pathRole}; i != ROLE_END; ++i, ++column_number) {
        roles.insert(i, this->columns[column_number]);
    }
    return roles;
}

bool Model::insert(const QString& filename, const QString& size, const QString& type, const QString& path, const QModelIndex &parent)
{
    int rowcount = rowCount();
    beginInsertRows(parent, rowcount, rowcount);

    QVariantList temp;
    temp.append(filename);
    temp.append(size);
    temp.append(type);
    temp.append(path);
    vlist.push_back(temp);
    endInsertRows();
    return true;
}

bool Model::prepareAndInsert(QString filepath)
{
    filepath.replace("file://", "");
    QFileInfo info(filepath);
    QStringList postfix{" B", " KB", " MB", " GB", " TB"};
    qint64 size{info.size()};
    if (size == 0) {
        return false;
    }
    size_t i{0};
    for (; i <= 4; ++i) {
        if (size > 1024) {
            size /= 1024;
        }else {
            break;
        }
    }
    insert(info.fileName(), QString(QString::number(size) + postfix[i]), info.completeSuffix(), filepath);
    return true;
}

QStringList Model::getFileInfo(int index) const
{
    QStringList fileinfo{vlist[index][3].toString(), vlist[index][0].toString()};
    return fileinfo;
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


