#include "comment.h"

Comment::Comment(QObject *parent) : QObject(parent)
{

}

Comment::Comment(const int id, const QString& author, const QString& text, const QString& date)
    : id(id), author(author), text(text), date(date)
{

}

QString Comment::getAuthor() const
{
    return author;
}

void Comment::setAuthor(const QString &value)
{
    if (value == author) {
        return;
    }
    author = value;
    emit authorChanged();
}

QString Comment::getText() const
{
    return text;
}

void Comment::setText(const QString &value)
{
    if (value == text) {
        return;
    }
    text = value;
    emit textChanged();
}

QString Comment::getDate() const
{
    return date;
}

void Comment::setDate(const QString &value)
{
    if (value == date) {
        return;
    }
    date = value;
    emit dateChanged();
}
