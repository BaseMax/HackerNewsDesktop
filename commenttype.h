#ifndef COMMENTTYPE_H
#define COMMENTTYPE_H

#include <QObject>
#include <vector>

class CommentType : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(int id READ getId WRITE setId)
    Q_PROPERTY(int parent READ getParent WRITE setParent)
    Q_PROPERTY(int indent READ getIndent WRITE setIndent)
    Q_PROPERTY(int childs READ childsNumber)
    Q_PROPERTY(QString author READ getAuthor WRITE setAuthor)
    Q_PROPERTY(QString date READ getDate WRITE setDate)
    Q_PROPERTY(QString text READ getText WRITE setText)
    CommentType(QObject* parent = nullptr);
    CommentType(int id, int parent, int indent,
                const QString& author, const QString& date, const QString& text, const std::vector<int>& childs );

    int getId() const;
    void setId(int value);

    int getParent() const;
    void setParent(int value);

    QString getAuthor() const;
    void setAuthor(const QString &value);

    QString getDate() const;
    void setDate(const QString &value);

    QString getText() const;
    void setText(const QString &value);

    std::vector<int> getChilds() const;
    void setChilds(const std::vector<int> &value);

    int getIndent() const;
    void setIndent(int value);

    int childsNumber() const;
private:
    int id, parent, indent;
    QString author, date, text;
    std::vector<int> childs;
};

#endif // COMMENTTYPE_H
