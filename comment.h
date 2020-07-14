#ifndef COMMENT_H
#define COMMENT_H

#include <QObject>

class Comment : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(QString author READ getAuthor WRITE setAuthor NOTIFY authorChanged)
    Q_PROPERTY(QString text READ getText WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QString date READ getDate WRITE setDate NOTIFY dateChanged)

    explicit Comment(QObject *parent = nullptr);
    Comment(const int id, const QString& author, const QString& text, const QString& date);

    QString getAuthor() const;
    void setAuthor(const QString &value);

    QString getText() const;
    void setText(const QString &value);

    QString getDate() const;
    void setDate(const QString &value);

signals:
    void authorChanged();
    void textChanged();
    void dateChanged();

private:
    int id;
    QString author, text, date;
};

#endif // COMMENT_H
