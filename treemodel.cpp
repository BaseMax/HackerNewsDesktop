#include "treemodel.h"

TreeModel::TreeModel(QObject *parent)
    : QAbstractItemModel(parent)
{
    QVector<QVariant> data{"Comments"};
    root = new TreeItem(data);
    Comment* c = new Comment(1, "alireza", "hello world", "22/85/2020 12:30:40");
    Comment* c1  = new Comment(2, "alireza", "hello world", "22/85/2020 12:30:40");
    Comment* c2  = new Comment(3, "alireza", "hello world", "22/85/2020 12:30:40");
    Comment* c3  = new Comment(4, "alireza", "hello world", "22/85/2020 12:30:40");
    root->insertChildren(0, 1);
    root->insertChildren(1, 1);
    root->insertChildren(2, 1);
    root->insertChildren(3, 1);
//    qDebug() << root->childCount();
    QVariant v;
    v.setValue(c);
    root->getChild(0)->setData(0, v);
    v.setValue(c1);
    root->getChild(0)->setData(0, v);
    v.setValue(c2);
    root->getChild(0)->setData(0, v);
    v.setValue(c3);
    root->getChild(0)->setData(0, v);
}

TreeModel::~TreeModel()
{
    delete root;
}

QModelIndex TreeModel::index(int row, int column, const QModelIndex &parent) const
{
    if (!hasIndex(row, column, parent)) {
        return QModelIndex();
    }
    TreeItem* parentItem;
    TreeItem* childItem;
    if (parent.isValid()) {
        parentItem = getItem(parent);
    } else {
        parentItem = this->root;
    }
    childItem = parentItem->getChild(row);
    if (childItem) {
        return createIndex(row, column, childItem);
    }
    return QModelIndex();
}

QModelIndex TreeModel::parent(const QModelIndex &index) const
{
    if (!index.isValid()) {
        return QModelIndex();
    }
    TreeItem* childItem = getItem(index);
    TreeItem* parentItem = childItem ? childItem->getParent() : nullptr;
    if (parentItem == this->root || !parentItem) {
        return QModelIndex();
    }
    return createIndex(parentItem->rowNumber(), 0, parentItem);
}

QHash<int, QByteArray> TreeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    int column_number{0};
    for (int i{ROLE_START + 1}; i != ROLE_END; ++i, ++column_number) {
        roles.insert(i, this->columns[column_number]);
    }
    return roles;
}

int TreeModel::rowCount(const QModelIndex &parent) const
{
    TreeItem* parentItem;
    if (!parent.isValid()) {
        parentItem = this->root;
    }
    parentItem = getItem(parent);
    return parentItem->childCount();
}

int TreeModel::columnCount(const QModelIndex &parent) const
{
    if (!parent.isValid()) {
        return this->root->columnCount();
    }
    return getItem(parent)->columnCount();

}

QVariant TreeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    TreeItem* item = static_cast<TreeItem*>(index.internalPointer());
    int column = role - ROLE_START - 1;
    if (role >= ROLE_END || role <= ROLE_START) {
        return QVariant();
    }
    return item->getData(column);
}

bool TreeModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (data(index, role) != value) {
        // FIXME: Implement me!
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags TreeModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable | QAbstractItemModel::flags(index);
}

bool TreeModel::insertRows(int row, int count, const QModelIndex &parent)
{
    beginInsertRows(parent, row, row + count - 1);
    // FIXME: Implement me!
    endInsertRows();
    return true;
}

//bool TreeModel::insertColumns(int column, int count, const QModelIndex &parent)
//{
//    beginInsertColumns(parent, column, column + count - 1);
//    // FIXME: Implement me!
//    endInsertColumns();
//}

bool TreeModel::removeRows(int row, int count, const QModelIndex &parent)
{
    beginRemoveRows(parent, row, row + count - 1);
    // FIXME: Implement me!
    endRemoveRows();
    return true;
}

//bool TreeModel::removeColumns(int column, int count, const QModelIndex &parent)
//{
//    beginRemoveColumns(parent, column, column + count - 1);
//    // FIXME: Implement me!
//    endRemoveColumns();
//}

TreeItem* TreeModel::getItem(const QModelIndex &index) const
{
    if (index.isValid()) {
        TreeItem* item = static_cast<TreeItem*>(index.internalPointer());
        if (item) {
            return item;
        }
    }
    return this->root;
}
