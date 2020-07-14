#ifndef TREEMODEL_H
#define TREEMODEL_H

#include <QAbstractItemModel>
#include "treeitem.h"
#include "comment.h"


#include <QDebug>

class TreeModel : public QAbstractItemModel
{
    Q_OBJECT

public:
    /*
     * roles for each column. ROLE_END is a flag for iteration convenience
     */
    enum {
        ROLE_START = Qt::UserRole + 1,
        commentRole,
//        authorRole,
//        dateRole,
//        textRole,
//        indentRole,
//        parentRole,
        ROLE_END
    };

    explicit TreeModel(QObject *parent = nullptr);
    ~TreeModel();
    // Header:
//    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

//    bool setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role = Qt::EditRole) override;

    // Basic functionality:
    QModelIndex index(int row, int column,
                      const QModelIndex &parent = QModelIndex()) const override;
    QModelIndex parent(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // Editable:
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    // Add data:
    bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
//    bool insertColumns(int column, int count, const QModelIndex &parent = QModelIndex()) override;

    // Remove data:
    bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
//    bool removeColumns(int column, int count, const QModelIndex &parent = QModelIndex()) override;

private:
    TreeItem* root;
    const QByteArrayList columns{"comment"};

    TreeItem* getItem(const QModelIndex& index) const;
};

#endif // TREEMODEL_H
