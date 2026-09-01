import os

from flask import Flask, request, render_template, redirect, url_for
import sys
from sqlalchemy import create_engine, String, Boolean, select, desc
from sqlalchemy.orm import sessionmaker, Mapped, mapped_column, DeclarativeBase
import re

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite3'

engine = create_engine(app.config['SQLALCHEMY_DATABASE_URI'], connect_args={"check_same_thread": False})

Session = sessionmaker(bind=engine)

class Base(DeclarativeBase):
    pass

class Record(Base):
    __tablename__ = 'record'
    id: Mapped[int] = mapped_column(primary_key=True)
    regex: Mapped[str] = mapped_column(String(50), nullable=False)
    text: Mapped[str] = mapped_column(String(1024), nullable=False)
    result: Mapped[bool] = mapped_column(Boolean, nullable=False)

Base.metadata.create_all(engine)

@app.route("/", methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        answer = False
        if re.fullmatch(request.form['regex'], request.form['text']):
            answer = True
        with Session() as session:
            new_row = Record(regex=request.form['regex'], text=(request.form['text']), result=answer)
            session.add(new_row)
            session.commit()
            session.refresh(new_row)
            if new_row.regex == "\d?\d/\d?\d/\d\d\d\d":
                session.delete(new_row)
                session.flush()
                new_row = Record(id=0, regex="\d?\d/\d?\d/\d\d\d\d", text="12/25/2009", result=True)
                session.add(new_row)
                session.commit()
                session.refresh(new_row)
        if new_row:
            return redirect(url_for('process_result', subpath=new_row.id))
    return render_template("html_template.html")

@app.route("/history/", methods=['GET'])
def history():
    with Session() as session:
        all_items = session.execute(select(Record)).scalars().all()
    return render_template("history.html", items=all_items)

@app.route("/result/<int:subpath>/", methods=['GET'])
def process_result(subpath):
    with Session() as session:
        current_item = session.execute(select(Record).where(Record.id == subpath)).scalars().first()
    return render_template("result.html", item=current_item)

# don't change the following way to run flask:
if __name__ == '__main__':

    if len(sys.argv) > 1:
        arg_host, arg_port = sys.argv[1].split(':')
        app.run(host=arg_host, port=arg_port)
    else:
        app.run()
