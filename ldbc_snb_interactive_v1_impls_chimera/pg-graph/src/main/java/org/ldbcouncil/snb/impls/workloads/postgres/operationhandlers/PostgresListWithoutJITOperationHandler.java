package org.ldbcouncil.snb.impls.workloads.postgres.operationhandlers;

import org.ldbcouncil.snb.driver.DbException;
import org.ldbcouncil.snb.driver.Operation;
import org.ldbcouncil.snb.driver.ResultReporter;
import org.ldbcouncil.snb.impls.workloads.operationhandlers.ListOperationHandler;
import org.ldbcouncil.snb.impls.workloads.postgres.PostgresDbConnectionState;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public abstract class PostgresListWithoutJITOperationHandler<TOperation extends Operation<List<TOperationResult>>, TOperationResult>
        extends PostgresOperationHandler
        implements ListOperationHandler<TOperationResult, TOperation, PostgresDbConnectionState> {

    @Override
    public void executeOperation(TOperation operation, PostgresDbConnectionState state,
                                 ResultReporter resultReporter) throws DbException {
        try {
            ResultSet result = null;
            Connection conn = state.getConnection();
            List<TOperationResult> results = new ArrayList<>();
            int resultCount = 0;
            results.clear();

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
            try {
                Statement jit_stmt = conn.createStatement();
                ResultSet jit_rs = jit_stmt.executeQuery("SET jit = off;");
                jit_rs.close();
            } catch (SQLException e) {}
    
            String queryString = getQueryString(state, operation);
            String queryStringWithParameterValue = replaceParameterNamesWithParameterValue(operation, queryString);
            // final PreparedStatement stmt = prepareAndSetParametersInPreparedStatement(operation, queryString, conn);
            final Statement stmt = conn.createStatement();
            state.logQuery(operation.getClass().getSimpleName(), queryString);
            
            try {
                result = stmt.executeQuery(queryStringWithParameterValue);
                while (result.next()) {
                    resultCount++;

                    TOperationResult tuple = convertSingleResult(result);
                    if (state.isPrintResults()) {
                        System.out.println(tuple.toString());
                    }
                    results.add(tuple);
                }
            } catch (SQLException e) {
                throw new DbException(e);
            }
            finally{
                if (result != null){
                    result.close();
                }
                stmt.close();
                conn.close();
            }

            resultReporter.report(resultCount, results, operation);

        }
        catch (SQLException e) {
            throw new DbException(e);
        }
    }

    public abstract TOperationResult convertSingleResult(ResultSet result) throws SQLException;
}
