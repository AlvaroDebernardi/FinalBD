import java.sql.*;
import java.util.Scanner;

public class App {
    public static void main(String[] args) {

        String jdbcURL = "jdbc:mysql://localhost:3306/proyectoBD";
        String username = "root";
        String password = "hernan1975";
        
        // intenta establecer la conexión con la base de datos
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(jdbcURL, username, password);
            System.out.println("\n¡Conexion exitosa a MySQL!");

            Scanner scanner = new Scanner(System.in);
            boolean salir = false;
            int opcion = 0;
            do {
                System.out.println("\nMenu de opciones:");
                System.out.println("1. Pelicula que tenga actores que son directores");
                System.out.println("2. Pelicula que haya tenido una rebaja del 50%");
                System.out.println("3. Pelicula que tenga origen de produccion en Argentina y España");
                System.out.println("4. Buscar cines que tengan salas para mas de 100 personas");
                System.out.println("5. Cantidad De butacas de cada cine.");
                System.out.println("6. Salir");

                System.out.print("Seleccione una opcion: ");
                opcion = scanner.nextInt();
              

                switch (opcion) {
                    case 1:
                        pelActoresComoDirectores(connection);
                        break;
                    case 2:
                        pelConRebajas(connection);
                        break;
                    case 3:
                        pelArgEsp(connection);
                        break;
                    case 4:
                        cinesSalasGrandes(connection);
                        break;
                    case 5:
                        cinesCantButacas(connection);
                        break;
                    case 6:
                        System.out.println("Saliendo del programa...");
                        salir = true;
                        break;
                    default:
                        System.out.println("Opcion no valida. Por favor, intente de nuevo.");
                        break;

                }

            } while (!salir);

        } catch (SQLException e) {
            System.out.println(
                    "Error al conectar con la base de datos: Recuerde modificar el archivo config.properties con los datos de su base de datos"
                            + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("Error inesperado: " + e.getMessage());
            e.printStackTrace();

        }
    }
    public static void pelActoresComoDirectores(Connection conn) {

        try{
            String sql = """
                SELECT TitOrig
                FROM Pelicula
                NATURAL JOIN (
                    SELECT *
                    FROM Actua
                    NATURAL JOIN Dirige
                ) AS pel;
                """;

            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            System.out.println();
            while (rs.next()) {
                String nombre = rs.getString("TitOrig");
                System.out.println(nombre);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        
    }

    public static void pelConRebajas(Connection conn) {

        try{
            String sql = """
                SELECT TitOrig FROM Pelicula NATURAL JOIN (
                    SELECT IDpel FROM Funcion NATURAL JOIN (
                        SELECT Codigo FROM Dispone 
                        NATURAL JOIN Promocion 
                        WHERE Promocion.Descuento>=50) 
                    AS fun) 
                AS pel;
            """;
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            System.out.println();
            while (rs.next()) {
                String nombre = rs.getString("TitOrig");
                System.out.println(nombre);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        
    }

    public static void pelArgEsp(Connection conn) {

        try{
            String sql = """
                SELECT TitOrig FROM Pelicula p WHERE p.IDpel IN ( 
                    SELECT IDpel FROM PaisProd 
                    WHERE Pais IN ('Argentina', 'España') 
                    GROUP BY IDpel HAVING COUNT(DISTINCT Pais) = 2);
            """;
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            System.out.println();
            while (rs.next()) {
                String nombre = rs.getString("TitOrig");
                System.out.println(nombre);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        
    }

    public static void cinesSalasGrandes(Connection conn) {

        try{
            String sql = "SELECT NomCine FROM Sala WHERE CantButacas>100;";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            System.out.println();
            while (rs.next()) {
                String nombre = rs.getString("NomCine");
                System.out.println(nombre);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        
    }

    public static void cinesCantButacas(Connection conn) {

        try{
            String sql = """
                SELECT NomCine,SUM(CantButacas) AS Butacas 
                FROM Sala GROUP BY NomCine;
            """;
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            System.out.println();
            while (rs.next()) {
                String nombre = rs.getString("NomCine");
                String cantButacas = rs.getString("Butacas");
                System.out.println(nombre + ": " + cantButacas);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
