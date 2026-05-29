// Data/DbContext.cs
using Dapper;
using Microsoft.Data.SqlClient;

namespace BancaCore.Data;

public class DbContext
{
    private readonly string _conn;
    public DbContext(IConfiguration config) =>
        _conn = config.GetConnectionString("BancaDB")!;

    public SqlConnection Open() => new SqlConnection(_conn);
}
