 # ADD A DATEPICKERRANGE COMPONENT FOR START & END DATE INPUT
# GO here for makeing dropdown bar chart (go to data and aggregate the covid information by month)
# https://community.plotly.com/t/how-to-connect-dropdown-to-bar-graph/40486/4

import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import pandas_datareader.data as web # requires v0.6.0 or later
from datetime import datetime
import plotly.graph_objs as go
import pandas as pd
import plotly.express as px
import dash_bootstrap_components as dbc
import dash_table
import os
import dash
#import cdata.mysql as mod
import plotly.graph_objs as go
#from flask_mysqldb import MySQL
import sqlalchemy
import mysql.connector


# CHANGE PASSWORD!!!!!!!!
database_username = 'blake'
database_password = 'S..
database_ip       = 'localhost'
database_name     = 'worldinformation'
database_connection = sqlalchemy.create_engine('mysql+mysqlconnector://{0}:{1}@{2}/{3}'.
                                               format(database_username, database_password, 
                                                      database_ip, database_name))


df = pd.read_sql("SELECT * FROM worldinformation.usacovid", database_connection)
 
 
external_stylesheets = [dbc.themes.BOOTSTRAP]
app = dash.Dash()
app.config.suppress_callback_exceptions = True

 
app.layout = html.Div(className='row', children=[
 html.Div( dash_table.DataTable(
        id='datatable-interactivity',
        columns=[
            {"name": i, "id": i, "deletable": True, "selectable": True} for i in df.columns
        ],
        data=df.to_dict('records'),
        editable=True,
        filter_action="native",
        sort_action="native",
        sort_mode="multi",
        column_selectable="single",
        row_selectable="multi",
        row_deletable=True,
        selected_columns=[],
        selected_rows=[],
        page_action="native",
        page_current= 0,
        page_size= 10,
    ))
 ])

if __name__ == '__main__':
     app.run_server()

