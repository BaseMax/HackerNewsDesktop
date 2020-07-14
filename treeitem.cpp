#include "treeitem.h"

TreeItem::TreeItem(QVector<QVariant> &data, TreeItem *parent)
    : data(data), parent(parent)
{

}

TreeItem::~TreeItem()
{
    qDeleteAll(childs);
}

void TreeItem::appenChild(TreeItem* child)
{
    this->childs.append(child);
}

TreeItem *TreeItem::getChild(int row)
{
    if (row < 0 || row > this->childs.size()) {
        return nullptr;
    }
    return this->childs[row];
}

int TreeItem::childCount() const
{
    return this->childs.count();
}

int TreeItem::columnCount() const
{
    return this->data.count();
}

int TreeItem::rowNumber() const
{
    if (this->parent) {
        return this->parent->childs.indexOf(const_cast<TreeItem*>(this));
    }
    return 0;
}

QVariant TreeItem::getData(int column) const
{
    if (column < 0 || column > this->data.size()) {
        return QVariant();
    }
    return this->data[column];
}

bool TreeItem::setData(int column, const QVariant &value)
{
    if (column < 0 || column >= this->data.size()) {
        return false;
    }
    this->data[column] = value;
    return true;
}

TreeItem *TreeItem::getParent()
{
    return this->parent;
}

bool TreeItem::insertChildren(int position, int columns)
{
    if (position < 0 || position > childs.size()) {
        return false;
    }
    QVector<QVariant> datas(columns);
    TreeItem* item = new TreeItem(datas, this);
    childs.insert(position, item);
    return true;
}

bool TreeItem::removeChildren(int position)
{
    if (position < 0 || position >= childs.size()) {
        return false;
    }
    delete childs.takeAt(position);
    return true;
}


