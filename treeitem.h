#ifndef TREEITEM_H
#define TREEITEM_H

#include <QVariant>
#include <QVector>

class TreeItem
{
public:
    explicit TreeItem(QVector<QVariant>& data, TreeItem* parent = nullptr);
    ~TreeItem();

    void appenChild(TreeItem* child);
    TreeItem* getChild(int row);
    int childCount() const;
    int columnCount() const;
    int rowNumber() const;
    QVariant getData(int column) const;
    bool setData(int column, const QVariant& value);
    TreeItem* getParent();
    bool insertChildren(int position, int column);
    bool removeChildren(int position);
private:
    QVector<TreeItem*> childs;
    QVector<QVariant> data;
    TreeItem* parent;
};

#endif // TREEITEM_H
