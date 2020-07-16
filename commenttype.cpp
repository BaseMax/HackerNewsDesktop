#include "commenttype.h"

CommentType::CommentType(QObject *parent)
    : QObject(parent)
{

}

CommentType::CommentType(int id, int parent, int indent,
                         const QString &author, const QString &date,
                         const QString &text, const std::vector<int> &childs)
    : id{id}, parent{parent}, indent(indent), author(author), date(date), text(text), childs(childs)
{

}

int CommentType::getId() const
{
    return id;
}

void CommentType::setId(int value)
{
    id = value;
}

int CommentType::getParent() const
{
    return parent;
}

void CommentType::setParent(int value)
{
    parent = value;
}

QString CommentType::getAuthor() const
{
    return author;
}

void CommentType::setAuthor(const QString &value)
{
    author = value;
}

QString CommentType::getDate() const
{
    return date;
}

void CommentType::setDate(const QString &value)
{
    date = value;
}

QString CommentType::getText() const
{
    return text;
}

void CommentType::setText(const QString &value)
{
    text = value;
}

std::vector<int> CommentType::getChilds() const
{
    return childs;
}

void CommentType::setChilds(const std::vector<int> &value)
{
    childs = value;
}

int CommentType::getIndent() const
{
    return indent;
}

void CommentType::setIndent(int value)
{
    indent = value;
}

int CommentType::childsNumber()
{
    return childs.size();
}
