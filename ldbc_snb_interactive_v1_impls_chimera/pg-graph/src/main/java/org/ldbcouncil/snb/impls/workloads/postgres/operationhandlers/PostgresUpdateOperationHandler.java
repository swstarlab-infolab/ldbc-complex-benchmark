package org.ldbcouncil.snb.impls.workloads.postgres.operationhandlers;

import org.ldbcouncil.snb.driver.DbException;
import org.ldbcouncil.snb.driver.Operation;
import org.ldbcouncil.snb.driver.ResultReporter;
import org.ldbcouncil.snb.driver.workloads.interactive.LdbcNoResult;
import org.ldbcouncil.snb.impls.workloads.operationhandlers.UpdateOperationHandler;
import org.ldbcouncil.snb.impls.workloads.postgres.PostgresDbConnectionState;

import java.sql.*;

public abstract class PostgresUpdateOperationHandler<TOperation extends Operation<LdbcNoResult>>
        extends PostgresOperationHandler
        implements UpdateOperationHandler<TOperation, PostgresDbConnectionState> {

    @Override
    public void executeOperation(TOperation operation, PostgresDbConnectionState state,
                                 ResultReporter resultReporter) throws DbException {
        try {
            Connection conn = state.getConnection();

            try {
                Statement load_stmt = conn.createStatement();
                ResultSet load_rs = load_stmt.executeQuery("LOAD 'pg_graph';");
                load_rs.close();
            } catch (SQLException e) {}
            try {
                Statement set_stmt = conn.createStatement();
                ResultSet set_rs = set_stmt.executeQuery("SET SEARCH_PATH=graph_catalog, '$user', public;");
                set_rs.close();
            } catch (SQLException e) {}
            try {
                Statement index_stmt = conn.createStatement();
                ResultSet index_rs = index_stmt.executeQuery("SET enable_indexonlyscan = off;");
                index_rs.close();
            } catch (SQLException e) {}
            try {
                Statement plan_stmt = conn.createStatement();
                ResultSet plan_rs = plan_stmt.executeQuery("SET enable_graphplan = on;");
                plan_rs.close();
            } catch (SQLException e) {}

            String queryString = getQueryString(state, operation);
            String queryStringWithParameterValue = replaceParameterNamesWithParameterValue(operation, queryString);
            // final PreparedStatement stmt = prepareAndSetParametersInPreparedStatement(operation, queryString, conn);
            final Statement stmt = conn.createStatement();
            state.logQuery(operation.getClass().getSimpleName(), queryString);
            
            try {
                state.logQuery(operation.getClass().getSimpleName(), queryString);
                stmt.executeQuery(queryStringWithParameterValue);
            } catch (Exception e) {
                // resultReporter.report(-1, LdbcNoResult.INSTANCE, operation);
                // return;
                throw new DbException(e);
            }
            finally {
                stmt.close();
                conn.close();
            }
            resultReporter.report(0, LdbcNoResult.INSTANCE, operation);
        }
        catch (SQLException e) {
            throw new DbException(e);
        }
    }
}
